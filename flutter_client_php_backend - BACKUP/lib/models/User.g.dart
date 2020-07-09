// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => new User(
    first_name: json['first_name'] as String,
    last_name: json['last_name'] as String,
    email: json['email'] as String,
    unique_id: json['unique_id'] as String,
    password: json['password'] as String,
    old_password: json['old_password'] as String,
    new_password: json['new_password'] as String);

abstract class _$UserSerializerMixin {
  String get first_name;

  String get last_name;

  String get email;

  String get unique_id;

  String get password;

  String get old_password;

  String get new_password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'unique_id': unique_id,
        'password': password,
        'old_password': old_password,
        'new_password': new_password
      };
}
