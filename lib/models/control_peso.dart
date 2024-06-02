// To parse this JSON data, do
//
//     final controlPeso = controlPesoFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_mario_garcia_app/models/descuento.dart';
import 'package:flutter_mario_garcia_app/models/lavador.dart';

ControlPeso controlPesoFromJson(String str) =>
    ControlPeso.fromJson(json.decode(str));

String controlPesoToJson(ControlPeso data) => json.encode(data.toJson());

class ControlPeso {
  String? id;
  String? idBusiness;
  String? businessName;
  String date;
  String hourInit;
  String? hourEnd;
  String month;
  String year;
  int timestamp;
  String embarcacion;
  String? operatorEmbarcacion;
  String idOperator;
  String controlPesoOperator;
  List<Lavador>? lavadores;
  List<double>? pesos;
  List<Descuento>? descuentoPesos;
  List<Descuento>? gastos;
  double? totalWeight;
  double? otherWeight;
  int? totalBox;
  int? boxEmpty;
  int? boxNoEmpty;
  int? recoveredBox;
  int? boxLost;
  String? conductor;
  String? placa;
  String? hourRun;
  String? hourLeave;
  String? bascula;
  String? tipo;
  String? status;
  String? comment;
  String? createdAt;

  ControlPeso({
    this.id,
    this.idBusiness,
    this.businessName,
    required this.date,
    required this.hourInit,
    this.hourEnd,
    required this.month,
    required this.year,
    required this.timestamp,
    required this.embarcacion,
    this.operatorEmbarcacion,
    required this.idOperator,
    required this.controlPesoOperator,
    this.lavadores,
    this.pesos,
    this.descuentoPesos,
    this.gastos,
    this.totalWeight,
    this.otherWeight,
    this.totalBox,
    this.boxEmpty,
    this.boxNoEmpty,
    this.recoveredBox,
    this.boxLost,
    this.conductor,
    this.placa,
    this.hourRun,
    this.hourLeave,
    this.bascula,
    this.tipo,
    this.status,
    this.comment,
    this.createdAt,
  });

  factory ControlPeso.fromJson(Map<String, dynamic> json) => ControlPeso(
        id: json["id"],
        idBusiness: json["id_business"],
        businessName: json["business_name"],
        date: json["date"],
        hourInit: json["hour_init"],
        hourEnd: json["hour_end"],
        month: json["month"],
        year: json["year"],
        timestamp: json["timestamp"] is String
            ? int.parse(json["timestamp"])
            : json["timestamp"],
        embarcacion: json["embarcacion"],
        operatorEmbarcacion: json["operator_embarcacion"],
        idOperator: json["id_operator"],
        controlPesoOperator: json["operator"],
        lavadores: json["lavadores"] == null
            ? []
            : List<Lavador>.from(
                json["lavadores"].map((x) => Lavador.fromJson(x))),
        pesos: json["pesos"] == null
            ? []
            : List<double>.from(json["pesos"].map((p) => p)),
        descuentoPesos: json["descuento_peso"] == null
            ? []
            : List<Descuento>.from(
                json["descuento_peso"].map((x) => Descuento.fromJson(x))),
        gastos: json["gastos"] == null
            ? []
            : List<Descuento>.from(
                json["gastos"].map((x) => Descuento.fromJson(x))),
        totalWeight: json["total_weight"] is String
            ? double.parse(json["total_weight"])
            : json["total_weight"] is int
                ? json["total_weight"]?.toDouble()
                : json["total_weight"],
        otherWeight: json["other_weight"] is String
            ? double.parse(json["other_weight"])
            : json["other_weight"] is int
                ? json["other_weight"]?.toDouble()
                : json["other_weight"],
        totalBox: json["total_box"] is String
            ? int.parse(json["total_box"])
            : json["total_box"] is double
                ? json["total_box"].toInt()
                : json["total_box"],
        boxEmpty: json["box_empty"] is String
            ? int.parse(json["box_empty"])
            : json["box_empty"] is double
                ? json["box_empty"].toInt()
                : json["box_empty"],
        boxNoEmpty: json["box_no_empty"] is String
            ? int.parse(json["box_no_empty"])
            : json["box_no_empty"] is double
                ? json["box_no_empty"].toInt()
                : json["box_no_empty"],
        recoveredBox: json["recovered_box"] is String
            ? int.parse(json["recovered_box"])
            : json["recovered_box"] is double
                ? json["recovered_box"].toInt()
                : json["recovered_box"],
        boxLost: json["box_lost"] is String
            ? int.parse(json["box_lost"])
            : json["box_lost"] is double
                ? json["box_lost"].toInt()
                : json["box_lost"],
        conductor: json["conductor"],
        placa: json["placa"],
        hourRun: json["hour_run"],
        hourLeave: json["hour_leave"],
        bascula: json["bascula"],
        status: json["status"],
        tipo: json["tipo"],
        comment: json["comment"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_business": idBusiness,
        "business_name": businessName,
        "date": date,
        "hour_init": hourInit,
        "hour_end": hourEnd,
        "month": month,
        "year": year,
        "timestamp": timestamp,
        "embarcacion": embarcacion,
        "operator_embarcacion": operatorEmbarcacion,
        "id_operator": idOperator,
        "operator": controlPesoOperator,
        "lavadores": lavadores,
        "pesos": pesos,
        "descuento_peso": descuentoPesos,
        "gastos": gastos,
        "total_weight": totalWeight,
        "other_weight": otherWeight,
        "total_box": totalBox,
        "box_empty": boxEmpty,
        "box_no_empty": boxNoEmpty,
        "box_lost": boxLost,
        "conductor": conductor,
        "placa": placa,
        "hour_run": hourRun,
        "hour_leave": hourLeave,
        "bascula": bascula,
        "tipo": tipo,
        "status": status,
        "comment": comment,
        "created_at": createdAt,
      };
}
