// To parse this JSON data, do
//
//     final registerPlanta = registerPlantaFromJson(jsonString);

import 'dart:convert';

RegisterPlanta registerPlantaFromJson(String str) =>
    RegisterPlanta.fromJson(json.decode(str));

String registerPlantaToJson(RegisterPlanta data) => json.encode(data.toJson());

class RegisterPlanta {
  String? id;
  String? idOperator;
  String? nameOperator;
  double? totalDescarga;
  int? batchRecibido;
  String? reportPesaje;
  String? typeTransport;
  String? planta;
  String? razonSocial;
  String? placa;
  String? hourInit;
  String? hourEnd;
  int? cuentaWzero;
  int? cuentaWspan;
  double? cuentaWval;
  double? coeficienteCal;
  List<String>? images;
  String? matricula;
  String? embarcacion;
  String? comments;
  String? status;
  int? timestamp;
  String? createdAt;

  RegisterPlanta({
    this.id,
    this.idOperator,
    this.nameOperator,
    this.totalDescarga,
    this.batchRecibido,
    this.reportPesaje,
    this.typeTransport,
    this.planta,
    this.razonSocial,
    this.placa,
    this.hourInit,
    this.hourEnd,
    this.cuentaWzero,
    this.cuentaWspan,
    this.cuentaWval,
    this.coeficienteCal,
    this.images,
    this.matricula,
    this.embarcacion,
    this.comments,
    this.status,
    this.timestamp,
    this.createdAt,
  });

  factory RegisterPlanta.fromJson(Map<String, dynamic> json) => RegisterPlanta(
        id: json["id"],
        idOperator: json["id_operator"],
        nameOperator: json["name_operator"],
        totalDescarga: json["total_descarga"]?.toDouble(),
        batchRecibido: json["batch_recibido"],
        reportPesaje: json["report_pesaje"],
        typeTransport: json["type_transport"],
        planta: json["planta"],
        razonSocial: json["razon_social"],
        placa: json["placa"],
        hourInit: json["hour_init"],
        hourEnd: json["hour_end"],
        cuentaWzero: json["cuenta_wzero"],
        cuentaWspan: json["cuenta_wspan"],
        cuentaWval: json["cuenta_wval"]?.toDouble(),
        coeficienteCal: json["coeficiente_cal"]?.toDouble(),
        images: List<String>.from(json["images"].map((x) => x)),
        matricula: json["matricula"],
        embarcacion: json["embarcacion"],
        comments: json["comments"],
        status: json["status"],
        timestamp: json["timestamp"] is String
            ? int.parse(json["timestamp"])
            : json["timestamp"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_operator": idOperator,
        "name_operator": nameOperator,
        "total_descarga": totalDescarga,
        "batch_recibido": batchRecibido,
        "report_pesaje": reportPesaje,
        "type_transport": typeTransport,
        "planta": planta,
        "razon_social": razonSocial,
        "placa": placa,
        "hour_init": hourInit,
        "hour_end": hourEnd,
        "cuenta_wzero": cuentaWzero,
        "cuenta_wspan": cuentaWspan,
        "cuenta_wval": cuentaWval,
        "coeficiente_cal": coeficienteCal,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "matricula": matricula,
        "embarcacion": embarcacion,
        "comments": comments,
        "status": status,
        "timestamp": timestamp,
        "created_at": createdAt,
      };
}
