// To parse this JSON data, do
//
//     final descuentoPeso = descuentoPesoFromJson(jsonString);

import 'dart:convert';

Descuento descuentoPesoFromJson(String str) =>
    Descuento.fromJson(json.decode(str));

String descuentoPesoToJson(Descuento data) => json.encode(data.toJson());

class Descuento {
  String name;
  double value;

  Descuento({
    required this.name,
    required this.value,
  });

  factory Descuento.fromJson(Map<String, dynamic> json) => Descuento(
        name: json["name"],
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}
