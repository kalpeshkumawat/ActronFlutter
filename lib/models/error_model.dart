import 'dart:convert';

DeviceErrorsModel deviceErrorsModelFromJson(String str) =>
    DeviceErrorsModel.fromJson(json.decode(str));

String deviceErrorsModelToJson(DeviceErrorsModel data) =>
    json.encode(data.toJson());

class DeviceErrorsModel {
  DeviceErrorsModel({
    required this.id,
    required this.errorCodes,
    required this.errorTimes,
    required this.errorDates,
  });

  String id;
  List<dynamic> errorCodes;
  List<dynamic> errorTimes;
  List<dynamic> errorDates;

  factory DeviceErrorsModel.fromJson(Map<String, dynamic> json) =>
      DeviceErrorsModel(
        id: json["id"],
        errorCodes: List<dynamic>.from(json["errorCodes"].map((x) => x)),
        errorTimes: List<dynamic>.from(json["errorTimes"].map((x) => x)),
        errorDates: List<dynamic>.from(json["errorDates"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "errorCodes": List<dynamic>.from(errorCodes.map((x) => x)),
        "errorTimes": List<dynamic>.from(errorTimes.map((x) => x)),
        "errorDates": List<dynamic>.from(errorDates.map((x) => x)),
      };
}
