import 'dart:convert';

DeviceDetailsModel devicesFromJson(String str) =>
    DeviceDetailsModel.fromJson(json.decode(str));

String devicesToJson(DeviceDetailsModel data) => json.encode(data.toJson());

class DeviceDetailsModel {
  DeviceDetailsModel({
    required this.name,
    required this.id,
    required this.model,
    required this.serial,
    required this.iduVersion,
    required this.oduVersion,
    required this.type,
    required this.comissionedDate,
    required this.lastUpdatedDate,
  });

  String name;
  String id;
  String model;
  String serial;
  String iduVersion;
  String oduVersion;
  int type;
  String comissionedDate;
  String lastUpdatedDate;

  factory DeviceDetailsModel.fromJson(Map<String, dynamic> json) =>
      DeviceDetailsModel(
        name: json["name"],
        id: json["id"],
        model: json["model"],
        serial: json["serial"],
        iduVersion: json["iduVersion"],
        oduVersion: json["oduVersion"],
        type: json["type"],
        comissionedDate: json["comissionedDate"],
        lastUpdatedDate: json["lastUpdatedDate"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "model": model,
        "serial": serial,
        "iduVersion": iduVersion,
        "oduVersion": oduVersion,
        "type": type,
        "comissionedDate": comissionedDate,
        "lastUpdatedDate": lastUpdatedDate
      };
}
