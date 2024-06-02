// To parse this JSON data, do
//
//     final support = supportFromJson(jsonString);

import 'dart:convert';

Support supportFromJson(String str) => Support.fromJson(json.decode(str));

String supportToJson(Support data) => json.encode(data.toJson());

class Support {
  Support({
    this.id,
    this.name,
    this.phone,
    this.email,
  });

  String? id;
  String? name;
  String? phone;
  String? email;

  factory Support.fromJson(Map<String, dynamic> json) => Support(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
      };
}
