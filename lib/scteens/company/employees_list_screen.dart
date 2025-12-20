import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'employee_details_screen.dart';

class EmployeesListScreen extends StatefulWidget {
  @override
  _EmployeesListScreenState createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  String _searchQuery = '';
  String? _selectedDepartment;
  String? _selectedStatus;

  List<String> departments = [
    'جميع الأقسام',
    'موارد بشرية',
    'خدمة عملاء',
    'صيانة',
    'تسويق',
    'محاسبة'
  ];
  List<String> statusList = ['جميع الحالات', 'شغال', 'أجازة', 'موقوف'];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees() {
    // TODO: جلب الموظفين من قاعدة البيانات
    // بيانات تجريبية
    employees = [
      Employee(
        id: '1',
        name: 'أحمد محمد',
        phone: '01234567890',
        email: 'ahmed@company.com',
        jobTitle: 'محاسب',
        department: 'محاسبة',
        basicSalary: 5000,
        workSchedule: '9-5',
        status: 'شغال',
        hireDate: DateTime(2023, 1, 15),
        password: '123456',
        role: 'موظف',
      ),
      Employee(
        id: '2',
        name: 'سارة علي',
        phone: '01123456789',
        email: 'sara@company.com',
        jobTitle: 'خدمة عملاء',
        department: 'خدمة عملاء',
        basicSalary: 4000,
        workSchedule: 'نوبات',
        status: 'أجازة',
        hireDate: DateTime(2023, 3, 20),
        password: '123456',
        role: 'موظف',
      ),
      Employee(
        id: '3',
        name: 'محمد حسن',
        phone: '01098765432',
        email: 'mohamed@company.com',
        jobTitle: 'مندوب',
        department: 'تسويق',
        basicSalary: 4500,
        workSchedule: 'ساعات مرنة',
        status: 'شغال',
        hireDate: DateTime(2023, 2, 10),
        password: '123456',
        role: 'مندوب',
      ),
    ];

    filteredEmployees = employees;
  }

  void _filterEmployees() {
    filteredEmployees = employees.where((employee) {
      bool matchesSearch = employee.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          employee.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesDepartment = _selectedDepartment == null ||
          _selectedDepartment == 'جميع الأقسام' ||
          employee.department == _selectedDepartment;

      bool matchesStatus = _selectedStatus == null ||
          _selectedStatus == 'جميع الحالات' ||
          employee.status == _selectedStatus;

      return matchesSearch && matchesDepartment && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة الموظفين'),
      ),
      body: Column(
        children: [
          // شريط البحث والتصفية
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // شريط البحث
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم الموظف أو الوظيفة...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterEmployees();
                    });
                  },
                ),

                SizedBox(height: 10),

                // أزرار التصفية
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDepartment,
                        decoration: InputDecoration(
                          hintText: 'القسم',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        items: departments.map((dept) {
                          return DropdownMenuItem(
                            value: dept,
                            child: Text(dept),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                            _filterEmployees();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          hintText: 'الحالة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        items: statusList.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                            _filterEmployees();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // قائمة الموظفين
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = filteredEmployees[index];
                return EmployeeCard(
                  employee: employee,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EmployeeDetailsScreen(employee: employee),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  EmployeeCard({required this.employee, required this.onTap});

  Color getStatusColor(String status) {
    switch (status) {
      case 'شغال':
        return Colors.green;
      case 'أجازة':
        return Colors.orange;
      case 'موقوف':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            employee.name.substring(0, 1),
            style: TextStyle(color: Colors.blue[800]),
          ),
        ),
        title: Text(
          employee.name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.jobTitle),
            Text(employee.department),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusColor(employee.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: getStatusColor(employee.status)),
              ),
              child: Text(
                employee.status,
                style: TextStyle(
                  color: getStatusColor(employee.status),
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${employee.basicSalary.toInt()} ج',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
