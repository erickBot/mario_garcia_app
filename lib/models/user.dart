// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String name;
  String lastname;
  String email;
  String? idRol;
  String? rolName;
  bool available;
  String? phone;
  String? imageUrl;
  String? token;
  String? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.available,
    this.idRol,
    this.rolName,
    this.phone,
    this.imageUrl,
    this.token,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        email: json["email"],
        idRol: json["id_rol"],
        rolName: json["rol_name"],
        available: json["available"],
        phone: json["phone"],
        imageUrl: json["image_url"],
        token: json["token"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "email": email,
        "id_rol": idRol,
        "rol_name": rolName,
        "available": available,
        "phone": phone,
        "image_url": imageUrl,
        "token": token,
        "created_at": createdAt,
      };
}
