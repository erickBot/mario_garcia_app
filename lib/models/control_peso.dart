// To parse this JSON data, do
//
//     final controlPeso = controlPesoFromJson(jsonString);

import 'dart:convert';

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
  List<String>? lavadores;
  double? totalWeight;
  double? otherWeight;
  String? idWeightList;
  String? idOtherWeightList;
  int? totalBox;
  int? boxEmpty;
  int? boxNoEmpty;
  String? conductor;
  String? placa;
  String? hourRun;
  String? bascula;
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
    this.totalWeight,
    this.otherWeight,
    this.idWeightList,
    this.idOtherWeightList,
    this.totalBox,
    this.boxEmpty,
    this.boxNoEmpty,
    this.conductor,
    this.placa,
    this.hourRun,
    this.bascula,
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
            : List<String>.from(json["lavadores"].map((x) => x)),
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
        idWeightList: json["id_weight_list"],
        idOtherWeightList: json["id_other_weight_list"],
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
        conductor: json["conductor"],
        placa: json["placa"],
        hourRun: json["hour_run"],
        bascula: json["bascula"],
        status: json["status"],
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
        "total_weight": totalWeight,
        "other_weight": otherWeight,
        "id_weight_list": idWeightList,
        "id_other_weight_list": idOtherWeightList,
        "total_box": totalBox,
        "box_empty": boxEmpty,
        "box_no_empty": boxNoEmpty,
        "conductor": conductor,
        "placa": placa,
        "hour_run": hourRun,
        "bascula": bascula,
        "status": status,
        "comment": comment,
        "created_at": createdAt,
      };
}
