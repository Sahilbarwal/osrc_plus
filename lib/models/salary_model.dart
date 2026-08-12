class SalaryModel {
  final String id;
  final String userId;
  final String month;
  final int totalDays;
  final double totalSalary;
  final bool paid;

  SalaryModel({
    required this.id,
    required this.userId,
    required this.month,
    required this.totalDays,
    required this.totalSalary,
    required this.paid,
  });

  factory SalaryModel.fromMap(Map<String, dynamic> map) {
    return SalaryModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      month: map['month'] as String,
      totalDays: (map['totalDays'] as num).toInt(),
      totalSalary: (map['totalSalary'] as num).toDouble(),
      paid: map['paid'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'month': month,
      'totalDays': totalDays,
      'totalSalary': totalSalary,
      'paid': paid,
    };
  }

  SalaryModel copyWith({
    String? id,
    String? userId,
    String? month,
    int? totalDays,
    double? totalSalary,
    bool? paid,
  }) {
    return SalaryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      totalDays: totalDays ?? this.totalDays,
      totalSalary: totalSalary ?? this.totalSalary,
      paid: paid ?? this.paid,
    );
  }
}
