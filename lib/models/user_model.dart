import 'package:flutter/cupertino.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String password; // Note: It's advisable to store hashed passwords instead of plaintext
  final String fullName;
  final DateTime dateOfBirth;
  final String imageUrl;
  final bool isAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.dateOfBirth,
    required this.imageUrl,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      fullName: json['fullName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      imageUrl: json['imageUrl'],
      isAdmin: json['isAdmin'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'imageUrl': imageUrl,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
