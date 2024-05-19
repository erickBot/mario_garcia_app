// To parse this JSON data, do
//
//     final business = businessFromJson(jsonString);

import 'dart:convert';

Business businessFromJson(String str) => Business.fromJson(json.decode(str));

String businessToJson(Business data) => json.encode(data.toJson());

class Business {
  String id;
  String name;
  String ruc;
  String address;

  Business({
    required this.id,
    required this.name,
    required this.ruc,
    required this.address,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json["id"],
        name: json["name"],
        ruc: json["ruc"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ruc": ruc,
        "address": address,
      };
}
