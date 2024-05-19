// To parse this JSON data, do
//
//     final lavador = lavadorFromJson(jsonString);

import 'dart:convert';

Lavador lavadorFromJson(String str) => Lavador.fromJson(json.decode(str));

String lavadorToJson(Lavador data) => json.encode(data.toJson());

class Lavador {
  String? id;
  String name;
  String lastname;
  String createdAt;

  Lavador({
    this.id,
    required this.name,
    required this.lastname,
    required this.createdAt,
  });

  factory Lavador.fromJson(Map<String, dynamic> json) => Lavador(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "created_at": createdAt,
      };
}
