import 'package:flutter/material.dart';

class MerchantStatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            "إحصائيات المحل",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.orange,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: "يومي"),
              Tab(text: "أسبوعي"),
              Tab(text: "شهري"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDailyStatistics(),
            _buildWeeklyStatistics(),
            _buildMonthlyStatistics(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStatistics() {
    final stats = _generateDailyStats();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // بطاقة الإحصائيات الرئيسية
          _buildStatsSummaryCard(stats['summary']!),
          SizedBox(height: 20),

          // المبيعات حسب المنتج
          _buildSalesByProduct(stats['products']!),
          SizedBox(height: 20),

          // مخطط بياني (مبسط)
          _buildSimpleChart(stats['chartData']!),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatistics() {
    final stats = _generateWeeklyStats();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatsSummaryCard(stats['summary']!),
          SizedBox(height: 20),
          _buildWeeklyTrend(stats['weeklyTrend']!),
          SizedBox(height: 20),
          _buildSalesByProduct(stats['products']!),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatistics() {
    final stats = _generateMonthlyStats();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatsSummaryCard(stats['summary']!),
          SizedBox(height: 20),
          _buildMonthlyComparison(stats['comparison']!),
          SizedBox(height: 20),
          _buildTopProducts(stats['topProducts']!),
        ],
      ),
    );
  }

  // بطاقة ملخص الإحصائيات
  Widget _buildStatsSummaryCard(Map<String, dynamic> summary) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange.shade600, Colors.orange.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade200,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "ملخص الإحصائيات",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.shopping_cart,
                "إجمالي المبيعات",
                "${summary['totalSales']} ج",
                Colors.white,
              ),
              _buildStatItem(
                Icons.attach_money,
                "عدد الطلبات",
                summary['ordersCount'].toString(),
                Colors.white,
              ),
              _buildStatItem(
                Icons.trending_up,
                "متوسط الطلب",
                "${summary['averageOrder']} ج",
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // عنصر إحصائي فردي
  Widget _buildStatItem(
      IconData icon, String title, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // قائمة المبيعات حسب المنتج
  Widget _buildSalesByProduct(List<Map<String, dynamic>> products) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "المبيعات حسب المنتج",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16),
            ...products.map((product) => _buildProductItem(product)).toList(),
          ],
        ),
      ),
    );
  }

  // عنصر المنتج في القائمة
  Widget _buildProductItem(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.inventory_2, color: Colors.orange, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "الكمية: ${product['quantity']}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${product['total']} ج",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getProgressColor(product['progress']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${product['progress']}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // مخطط بياني مبسط
  Widget _buildSimpleChart(List<Map<String, dynamic>> chartData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مخطط المبيعات",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: chartData.map((data) => _buildBar(data)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // شريط في المخطط البياني
  Widget _buildBar(Map<String, dynamic> data) {
    return Column(
      children: [
        Container(
          width: 20,
          height: data['value'] * 2.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.orange.shade600, Colors.orange.shade300],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 8),
        Text(
          data['label'],
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // اتجاه المبيعات الأسبوعي
  Widget _buildWeeklyTrend(List<Map<String, dynamic>> trend) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الاتجاه الأسبوعي",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16),
            ...trend.map((day) => _buildTrendItem(day)).toList(),
          ],
        ),
      ),
    );
  }

  // عنصر في الاتجاه الأسبوعي
  Widget _buildTrendItem(Map<String, dynamic> day) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day['day'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: day['progress'] / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(day['progress'])),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${day['value']} ج",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // مقارنة الشهري
  Widget _buildMonthlyComparison(Map<String, dynamic> comparison) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مقارنة مع الشهر الماضي",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildComparisonItem("هذا الشهر", comparison['current'],
                    Icons.arrow_upward, Colors.green),
                _buildComparisonItem("الشهر الماضي", comparison['previous'],
                    Icons.arrow_downward, Colors.red),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: comparison['growth'] >= 0
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: comparison['growth'] >= 0
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    comparison['growth'] >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color:
                        comparison['growth'] >= 0 ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "نمو ${comparison['growth']}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          comparison['growth'] >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // عنصر المقارنة
  Widget _buildComparisonItem(
      String title, int value, IconData icon, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 4),
            Text(
              "$value ج",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // أفضل المنتجات
  Widget _buildTopProducts(List<Map<String, dynamic>> products) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "أفضل المنتجات مبيعاً",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16),
            ...products
                .asMap()
                .entries
                .map(
                    (entry) => _buildTopProductItem(entry.value, entry.key + 1))
                .toList(),
          ],
        ),
      ),
    );
  }

  // عنصر أفضل منتج
  Widget _buildTopProductItem(Map<String, dynamic> product, int rank) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                "$rank",
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
                  product['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${product['sales']} مبيعات",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${product['revenue']} ج",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة للألوان
  Color _getProgressColor(double progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 50) return Colors.orange;
    return Colors.red;
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  // بيانات تجريبية
  Map<String, dynamic> _generateDailyStats() {
    return {
      'summary': {
        'totalSales': 12500,
        'ordersCount': 45,
        'averageOrder': 278,
      },
      'products': List.generate(
          5,
          (index) => {
                'name': 'منتج ${index + 1}',
                'quantity': (index + 1) * 3,
                'total': ((index + 1) * 3) * 50,
                'progress': [85, 70, 60, 45, 30][index],
              }),
      'chartData': List.generate(
          7,
          (index) => {
                'label': [
                  'أحد',
                  'اثنين',
                  'ثلاثاء',
                  'أربعاء',
                  'خميس',
                  'جمعة',
                  'سبت'
                ][index],
                'value': [30, 45, 35, 50, 40, 65, 55][index],
              }),
    };
  }

  Map<String, dynamic> _generateWeeklyStats() {
    return {
      'summary': {
        'totalSales': 87500,
        'ordersCount': 315,
        'averageOrder': 278,
      },
      'weeklyTrend': List.generate(
          7,
          (index) => {
                'day': [
                  'الأحد',
                  'الإثنين',
                  'الثلاثاء',
                  'الأربعاء',
                  'الخميس',
                  'الجمعة',
                  'السبت'
                ][index],
                'value': [
                  12000,
                  11500,
                  12500,
                  13000,
                  14000,
                  15500,
                  9000
                ][index],
                'progress': [75, 70, 78, 82, 88, 97, 56][index],
              }),
      'products': List.generate(
          5,
          (index) => {
                'name': 'منتج ${index + 1}',
                'quantity': (index + 1) * 15,
                'total': ((index + 1) * 15) * 50,
                'progress': [90, 75, 65, 55, 40][index],
              }),
    };
  }

  Map<String, dynamic> _generateMonthlyStats() {
    return {
      'summary': {
        'totalSales': 350000,
        'ordersCount': 1260,
        'averageOrder': 278,
      },
      'comparison': {
        'current': 350000,
        'previous': 295000,
        'growth': 18.6,
      },
      'topProducts': List.generate(
          5,
          (index) => {
                'name': 'منتج ${index + 1}',
                'sales': [450, 380, 320, 290, 250][index],
                'revenue': [22500, 19000, 16000, 14500, 12500][index],
              }),
    };
  }
}
