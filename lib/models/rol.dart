// To parse this JSON data, do
//
//     final rol = rolFromJson(jsonString);

import 'dart:convert';

Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  String id;
  String name;
  String route;

  Rol({
    required this.id,
    required this.name,
    required this.route,
  });

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        id: json["id"],
        name: json["name"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "route": route,
      };
}
