
import 'employee_model.dart';

class EmployeeService {
  // محاكاة قاعدة بيانات
  List<Employee> _employees = [];
  
  // إضافة موظف جديد
  Future<void> addEmployee(Employee employee) async {
    _employees.add(employee);
    await Future.delayed(Duration(seconds: 1)); // محاكاة اتصال شبكة
  }
  
  // جلب جميع الموظفين
  Future<List<Employee>> getAllEmployees() async {
    await Future.delayed(Duration(seconds: 1));
    return _employees;
  }
  
  // البحث عن موظف
  Future<List<Employee>> searchEmployees(String query) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _employees.where((employee) {
      return employee.name.toLowerCase().contains(query.toLowerCase()) ||
             employee.jobTitle.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  
  // تحديث موظف
  Future<void> updateEmployee(Employee updatedEmployee) async {
    int index = _employees.indexWhere((e) => e.id == updatedEmployee.id);
    if (index != -1) {
      _employees[index] = updatedEmployee;
    }
    await Future.delayed(Duration(seconds: 1));
  }
  
  // حذف موظف
  Future<void> deleteEmployee(String employeeId) async {
    _employees.removeWhere((e) => e.id == employeeId);
    await Future.delayed(Duration(seconds: 1));
  }
  
  // جلب موظف بواسطة ID
  Future<Employee?> getEmployeeById(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _employees.firstWhere((e) => e.id == id);
  }
}