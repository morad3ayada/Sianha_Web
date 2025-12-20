import 'package:flutter/material.dart';
import 'completed_order.dart';

// --- تعريفات فئات بيانات الإحصائيات المفقودة والمطلوبة ---

class CenterPerformance {
  final String governorate;
  final String center;
  final int totalOrders;
  final double totalRevenue;
  final double averageRating;

  CenterPerformance({
    required this.governorate,
    required this.center,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageRating,
  });
}

class ServiceStats {
  final String serviceType;
  final int requestCount;
  final double totalRevenue;

  ServiceStats({
    required this.serviceType,
    required this.requestCount,
    required this.totalRevenue,
  });
}

class TechnicianStats {
  final String technicianId;
  final String technicianName;
  final String governorate;
  final String center;
  final int completedOrders;
  final double averageRating;
  final double totalRevenue;

  TechnicianStats({
    required this.technicianId,
    required this.technicianName,
    required this.governorate,
    required this.center,
    required this.completedOrders,
    required this.averageRating,
    required this.totalRevenue,
  });
}

class GovernoratePerformance {
  final String governorate;
  final int totalOrders;
  final double totalRevenue;
  final double averageRating;

  GovernoratePerformance({
    required this.governorate,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageRating,
  });
}

class AdvancedStats {
  final List<CenterPerformance> topCenters;
  final List<ServiceStats> topServices;
  final List<TechnicianStats> topTechnicians;
  final List<GovernoratePerformance> governoratePerformance;

  AdvancedStats({
    required this.topCenters,
    required this.topServices,
    required this.topTechnicians,
    required this.governoratePerformance,
  });
}

// --- فئة الواجهة الرئيسية (StatefulWidget) ---

class AdvancedStatsScreen extends StatefulWidget {
  final Map<String, List<CompletedOrder>> allOrders;

  const AdvancedStatsScreen({Key? key, required this.allOrders})
      : super(key: key);

  @override
  _AdvancedStatsScreenState createState() => _AdvancedStatsScreenState();
}

class _AdvancedStatsScreenState extends State<AdvancedStatsScreen> {
  String? _selectedGovernorate;
  String? _selectedServiceType;
  String? _selectedTimeRange;

  // قوائم الفلاتر
  List<String> get _governorates => widget.allOrders.keys.toList();

  final List<String> _serviceTypes = [
    'جميع الخدمات',
    'كهرباء',
    'سباكة',
    'صيانة موبايل',
    'ونش',
    'تكييف وتبريد',
    'نجارة',
    'حدادة',
    'دهانات'
  ];

  final List<String> _timeRanges = [
    'جميع الفترات',
    'آخر أسبوع',
    'آخر شهر',
    'آخر 3 أشهر',
    'آخر سنة'
  ];

  // دالة لحساب الإحصائيات المتقدمة مع الفلاتر
  AdvancedStats _calculateAdvancedStats() {
    List<CenterPerformance> topCenters = [];
    Map<String, ServiceStats> serviceStats = {};
    Map<String, TechnicianStats> technicianStats = {};
    List<GovernoratePerformance> governoratePerformance = [];

    // فلترة البيانات حسب المحافظة المختارة
    Map<String, List<CompletedOrder>> filteredOrders = {};

    if (_selectedGovernorate == null ||
        _selectedGovernorate == 'جميع المحافظات') {
      filteredOrders = widget.allOrders;
    } else {
      filteredOrders[_selectedGovernorate!] =
          widget.allOrders[_selectedGovernorate] ?? [];
    }

    // معالجة البيانات المفلترة
    filteredOrders.forEach((governorate, orders) {
      // فلترة إضافية حسب نوع الخدمة إذا كان محدد
      List<CompletedOrder> filteredServiceOrders = orders;
      if (_selectedServiceType != null &&
          _selectedServiceType != 'جميع الخدمات') {
        filteredServiceOrders = orders
            .where((order) => order.serviceType == _selectedServiceType)
            .toList();
      }

      // فلترة حسب الوقت إذا كان محدد
      List<CompletedOrder> finalOrders =
          _filterByTimeRange(filteredServiceOrders);

      if (finalOrders.isEmpty) return;

      // أداء المحافظة
      int govTotalOrders = finalOrders.length;
      double govTotalRevenue =
          finalOrders.fold(0.0, (sum, order) => sum + order.price);
      double govTotalRating =
          finalOrders.fold(0.0, (sum, order) => sum + order.rating);
      double govAvgRating =
          govTotalOrders > 0 ? govTotalRating / govTotalOrders : 0.0;

      governoratePerformance.add(GovernoratePerformance(
        governorate: governorate,
        totalOrders: govTotalOrders,
        totalRevenue: govTotalRevenue,
        averageRating: govAvgRating,
      ));

      // تجميع البيانات حسب المركز
      Map<String, List<CompletedOrder>> centerOrders = {};
      for (var order in finalOrders) {
        String centerKey = '${order.governorate}-${order.center}';
        if (!centerOrders.containsKey(centerKey)) {
          centerOrders[centerKey] = [];
        }
        centerOrders[centerKey]!.add(order);
      }

      // أداء المراكز
      centerOrders.forEach((centerKey, centerOrders) {
        int centerTotalOrders = centerOrders.length;
        double centerTotalRevenue =
            centerOrders.fold(0.0, (sum, order) => sum + order.price);
        double centerTotalRating =
            centerOrders.fold(0.0, (sum, order) => sum + order.rating);
        double centerAvgRating =
            centerTotalOrders > 0 ? centerTotalRating / centerTotalOrders : 0.0;

        List<String> parts = centerKey.split('-');
        topCenters.add(CenterPerformance(
          governorate: parts[0],
          center: parts[1],
          totalOrders: centerTotalOrders,
          totalRevenue: centerTotalRevenue,
          averageRating: centerAvgRating,
        ));
      });

      // إحصائيات الخدمات
      for (var order in finalOrders) {
        String serviceType = order.serviceType;
        if (!serviceStats.containsKey(serviceType)) {
          serviceStats[serviceType] = ServiceStats(
            serviceType: serviceType,
            requestCount: 0,
            totalRevenue: 0,
          );
        }
        serviceStats[serviceType] = ServiceStats(
          serviceType: serviceType,
          requestCount: serviceStats[serviceType]!.requestCount + 1,
          totalRevenue: serviceStats[serviceType]!.totalRevenue + order.price,
        );
      }

      // إحصائيات الفنيين
      for (var order in finalOrders) {
        String technicianId = order.technicianId;
        if (!technicianStats.containsKey(technicianId)) {
          technicianStats[technicianId] = TechnicianStats(
            technicianId: technicianId,
            technicianName: order.technicianName,
            governorate: order.governorate,
            center: order.center,
            completedOrders: 0,
            averageRating: 0,
            totalRevenue: 0,
          );
        }

        var current = technicianStats[technicianId]!;
        technicianStats[technicianId] = TechnicianStats(
          technicianId: technicianId,
          technicianName: order.technicianName,
          governorate: order.governorate,
          center: order.center,
          completedOrders: current.completedOrders + 1,
          averageRating: ((current.averageRating * current.completedOrders) +
                  order.rating) /
              (current.completedOrders + 1),
          totalRevenue: current.totalRevenue + order.price,
        );
      }
    });

    // ترتيب البيانات
    topCenters.sort((a, b) => b.totalOrders.compareTo(a.totalOrders));

    var sortedServices = serviceStats.values.toList()
      ..sort((a, b) => b.requestCount.compareTo(a.requestCount));

    var sortedTechnicians = technicianStats.values.toList()
      ..sort((a, b) => b.completedOrders.compareTo(a.completedOrders));

    governoratePerformance
        .sort((a, b) => b.totalOrders.compareTo(a.totalOrders));

    return AdvancedStats(
      topCenters: topCenters.take(10).toList(),
      topServices: sortedServices.take(3).toList(),
      topTechnicians: sortedTechnicians.take(10).toList(),
      governoratePerformance: governoratePerformance,
    );
  }

  // دالة فلترة حسب الوقت
  List<CompletedOrder> _filterByTimeRange(List<CompletedOrder> orders) {
    if (_selectedTimeRange == null || _selectedTimeRange == 'جميع الفترات') {
      return orders;
    }

    DateTime now = DateTime.now();
    DateTime filterDate;

    switch (_selectedTimeRange) {
      case 'آخر أسبوع':
        filterDate = now.subtract(Duration(days: 7));
        break;
      case 'آخر شهر':
        filterDate = now.subtract(Duration(days: 30));
        break;
      case 'آخر 3 أشهر':
        filterDate = now.subtract(Duration(days: 90));
        break;
      case 'آخر سنة':
        filterDate = now.subtract(Duration(days: 365));
        break;
      default:
        return orders;
    }

    return orders
        .where((order) => order.completionDate.isAfter(filterDate))
        .toList();
  }

  // دالة إعادة تعيين الفلاتر
  void _resetFilters() {
    setState(() {
      _selectedGovernorate = null;
      _selectedServiceType = null;
      _selectedTimeRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateAdvancedStats();
    final hasFilters = _selectedGovernorate != null ||
        _selectedServiceType != null ||
        _selectedTimeRange != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('الإحصائيات المتقدمة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple[700],
        centerTitle: true,
        actions: [
          if (hasFilters)
            IconButton(
              icon: Icon(Icons.filter_alt_off, color: Colors.white),
              onPressed: _resetFilters,
              tooltip: 'إعادة تعيين الفلاتر',
            ),
        ],
      ),
      body: Column(
        children: [
          // 🎛️ قسم الفلاتر
          _buildFiltersSection(),

          // 📊 قسم الإحصائيات
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // مؤشر الفلترة النشطة
                        if (hasFilters) _buildActiveFiltersIndicator(),

                        // 🏆 أفضل 10 مراكز أداء
                        _buildSection(
                          title: 'أفضل 10 مراكز أداء',
                          icon: Icons.emoji_events,
                          color: Colors.amber,
                          children: [
                            if (stats.topCenters.isEmpty)
                              _buildEmptyState(
                                  'لا توجد بيانات للمراكز مع الفلاتر المحددة')
                            else
                              Column(
                                children: [
                                  for (int i = 0;
                                      i < stats.topCenters.length;
                                      i++)
                                    _buildPerformanceCard(
                                      rank: i + 1,
                                      title: '${stats.topCenters[i].center}',
                                      subtitle:
                                          '${stats.topCenters[i].governorate}',
                                      value:
                                          '${stats.topCenters[i].totalOrders} طلب',
                                      secondaryValue:
                                          '${stats.topCenters[i].averageRating.toStringAsFixed(1)} ⭐',
                                      color: _getRankColor(i + 1),
                                    ),
                                ],
                              ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // 🔧 أفضل 3 تخصصات مطلوبة
                        _buildSection(
                          title: 'أكثر التخصصات طلباً',
                          icon: Icons.build,
                          color: Colors.blue,
                          children: [
                            if (stats.topServices.isEmpty)
                              _buildEmptyState(
                                  'لا توجد بيانات للخدمات مع الفلاتر المحددة')
                            else
                              Column(
                                children: [
                                  for (int i = 0;
                                      i < stats.topServices.length;
                                      i++)
                                    _buildServiceCard(
                                      rank: i + 1,
                                      service: stats.topServices[i].serviceType,
                                      requests:
                                          stats.topServices[i].requestCount,
                                      revenue:
                                          stats.topServices[i].totalRevenue,
                                    ),
                                ],
                              ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // 👨‍🔧 أفضل 10 فنيين
                        _buildSection(
                          title: 'أفضل 10 فنيين',
                          icon: Icons.engineering,
                          color: Colors.green,
                          children: [
                            if (stats.topTechnicians.isEmpty)
                              _buildEmptyState(
                                  'لا توجد بيانات للفنيين مع الفلاتر المحددة')
                            else
                              Column(
                                children: [
                                  for (int i = 0;
                                      i < stats.topTechnicians.length;
                                      i++)
                                    _buildTechnicianCard(
                                      rank: i + 1,
                                      name: stats
                                          .topTechnicians[i].technicianName,
                                      location:
                                          '${stats.topTechnicians[i].governorate} - ${stats.topTechnicians[i].center}',
                                      orders: stats
                                          .topTechnicians[i].completedOrders,
                                      rating:
                                          stats.topTechnicians[i].averageRating,
                                      revenue:
                                          stats.topTechnicians[i].totalRevenue,
                                    ),
                                ],
                              ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // 📈 أداء المحافظات
                        _buildSection(
                          title: 'أداء المحافظات',
                          icon: Icons.analytics,
                          color: Colors.purple,
                          children: [
                            if (stats.governoratePerformance.isEmpty)
                              _buildEmptyState(
                                  'لا توجد بيانات للمحافظات مع الفلاتر المحددة')
                            else
                              Column(
                                children: [
                                  for (var gov in stats.governoratePerformance)
                                    _buildGovernorateCard(
                                      governorate: gov.governorate,
                                      orders: gov.totalOrders,
                                      revenue: gov.totalRevenue,
                                      rating: gov.averageRating,
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // واجهة الفلاتر
  Widget _buildFiltersSection() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'فلاتر البحث',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            // استخدام MediaQuery للاستجابة للشاشات الصغيرة
            MediaQuery.of(context).size.width < 600
                ? Column(
                    children: [
                      // فلترة المحافظة
                      DropdownButtonFormField<String>(
                        value: _selectedGovernorate,
                        decoration: InputDecoration(
                          labelText: 'المحافظة',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: null, child: Text('جميع المحافظات')),
                          ..._governorates.map((gov) =>
                              DropdownMenuItem(value: gov, child: Text(gov))),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGovernorate = value;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      // فلترة نوع الخدمة
                      DropdownButtonFormField<String>(
                        value: _selectedServiceType,
                        decoration: InputDecoration(
                          labelText: 'نوع الخدمة',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: _serviceTypes
                            .map((service) => DropdownMenuItem(
                                value: service, child: Text(service)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedServiceType = value;
                          });
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      // فلترة المحافظة
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedGovernorate,
                          decoration: InputDecoration(
                            labelText: 'المحافظة',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          ),
                          items: [
                            DropdownMenuItem(
                                value: null, child: Text('جميع المحافظات')),
                            ..._governorates.map((gov) =>
                                DropdownMenuItem(value: gov, child: Text(gov))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGovernorate = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      // فلترة نوع الخدمة
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedServiceType,
                          decoration: InputDecoration(
                            labelText: 'نوع الخدمة',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          ),
                          items: _serviceTypes
                              .map((service) => DropdownMenuItem(
                                  value: service, child: Text(service)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedServiceType = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 12),
            // فلترة الفترة الزمنية
            DropdownButtonFormField<String>(
              value: _selectedTimeRange,
              decoration: InputDecoration(
                labelText: 'الفترة الزمنية',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              items: _timeRanges
                  .map((time) =>
                      DropdownMenuItem(value: time, child: Text(time)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTimeRange = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // مؤشر الفلاتر النشطة
  Widget _buildActiveFiltersIndicator() {
    List<String> activeFilters = [];

    if (_selectedGovernorate != null) activeFilters.add(_selectedGovernorate!);
    if (_selectedServiceType != null && _selectedServiceType != 'جميع الخدمات')
      activeFilters.add(_selectedServiceType!);
    if (_selectedTimeRange != null && _selectedTimeRange != 'جميع الفترات')
      activeFilters.add(_selectedTimeRange!);

    if (activeFilters.isEmpty) return SizedBox();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt, color: Colors.blue, size: 16),
          SizedBox(width: 8),
          Text(
            'الفلاتر النشطة:',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700]),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              activeFilters.join(' • '),
              style: TextStyle(color: Colors.blue[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard({
    required int rank,
    required String title,
    required String subtitle,
    required String value,
    required String secondaryValue,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  secondaryValue,
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required int rank,
    required String service,
    required int requests,
    required double revenue,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getServiceColor(service),
          child: Icon(_getServiceIcon(service), color: Colors.white, size: 20),
        ),
        title: Text(
          service,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('$requests طلب'),
        trailing: Container(
          constraints: BoxConstraints(maxWidth: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${revenue.toStringAsFixed(0)} جنيه',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text('المركز $rank',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicianCard({
    required int rank,
    required String name,
    required String location,
    required int orders,
    required double rating,
    required double revenue,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue, size: 20),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          constraints: BoxConstraints(maxWidth: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$orders طلب',
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  Text(
                    ' ${rating.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGovernorateCard({
    required String governorate,
    required int orders,
    required double revenue,
    required double rating,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    governorate,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('$orders طلب',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${revenue.toStringAsFixed(0)} جنيه',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        ' ${rating.toStringAsFixed(1)}',
                        style: TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange[300]!;
      default:
        return Colors.blue[100]!;
    }
  }

  Color _getServiceColor(String service) {
    switch (service) {
      case 'كهرباء':
        return Colors.amber;
      case 'سباكة':
        return Colors.blue;
      case 'صيانة موبايل':
        return Colors.green;
      case 'ونش':
        return Colors.orange;
      case 'تكييف وتبريد':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceIcon(String service) {
    switch (service) {
      case 'كهرباء':
        return Icons.electrical_services;
      case 'سباكة':
        return Icons.plumbing;
      case 'صيانة موبايل':
        return Icons.smartphone;
      case 'ونش':
        return Icons.local_shipping;
      case 'تكييف وتبريد':
        return Icons.ac_unit;
      default:
        return Icons.build;
    }
  }
}
