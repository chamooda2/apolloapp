import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutritrack/models/role.dart';

class UserModel {
  final String name;
  final Role role;
  final String empID;
  final String phoneNumber;
  final DateTime createdAt;

  UserModel({
    required this.name,
    required this.role,
    required this.empID,
    required this.phoneNumber,
    required this.createdAt,
  });

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role.toString().split('.').last, // Convert enum to string
      'empID': empID,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }

  // Convert Firestore Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      role: Role.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
        orElse: () => Role.Nutritionist, // Default value
      ),
      empID: map['empID'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
