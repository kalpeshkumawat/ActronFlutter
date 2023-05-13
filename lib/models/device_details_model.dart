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
    required this.type,
    required this.date,
  });

  String name;
  String id;
  String model;
  String serial;
  String type;
  String date;

  factory DeviceDetailsModel.fromJson(Map<String, dynamic> json) =>
      DeviceDetailsModel(
        name: json["name"],
        id: json["id"],
        model: json["model"],
        serial: json["serial"],
        type: json["type"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "model": model,
        "serial": serial,
        "type": type,
        "date": date,
      };
}
