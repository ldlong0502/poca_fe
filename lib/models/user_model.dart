import 'package:flutter/cupertino.dart';

class UserModel {
  final int userId;
  final String name;
  final String phone;
  final String email;

  UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['user_id'] ?? 0,
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '');
  }
}
