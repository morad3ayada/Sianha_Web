
class Salary {
  String id;
  String employeeId;
  DateTime month;
  double basicSalary;
  List<Deduction> deductions;
  List<Bonus> bonuses;
  bool isPaid;
  
  Salary({
    required this.id,
    required this.employeeId,
    required this.month,
    required this.basicSalary,
    required this.deductions,
    required this.bonuses,
    required this.isPaid,
  });
  
  double get totalDeductions {
    return deductions.fold(0, (sum, deduction) => sum + deduction.amount);
  }
  
  double get totalBonuses {
    return bonuses.fold(0, (sum, bonus) => sum + bonus.amount);
  }
  
  double get netSalary {
    return basicSalary - totalDeductions + totalBonuses;
  }
}

class Deduction {
  String id;
  double amount;
  String reason;
  DateTime date;
  
  Deduction({
    required this.id,
    required this.amount,
    required this.reason,
    required this.date,
  });
}

class Bonus {
  String id;
  double amount;
  String reason;
  DateTime date;
  
  Bonus({
    required this.id,
    required this.amount,
    required this.reason,
    required this.date,
  });
}