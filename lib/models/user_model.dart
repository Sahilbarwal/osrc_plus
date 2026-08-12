class UserModel {
  final String id;
  final String name;
  final String phone;
  final String role; // admin or worker
  final double salaryPerDay;
  final String? assignedSite;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.salaryPerDay,
    this.assignedSite,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      role: map['role'] as String,
      salaryPerDay: (map['salaryPerDay'] as num).toDouble(),
      assignedSite: map['assignedSite'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'salaryPerDay': salaryPerDay,
      'assignedSite': assignedSite,
    };
  }
}
