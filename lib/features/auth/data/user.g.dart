// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  username: json['username'] as String?,
  firstname: json['firstname'] as String?,
  lastname: json['lastname'] as String?,
  email: json['email'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  isActive: json['is_active'] as bool?,
  isGuest: json['is_guest'] as bool?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'email': instance.email,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'is_active': instance.isActive,
  'is_guest': instance.isGuest,
};
