import 'dart:convert';

SystemConfigModel systemConfigModelFromJson(String str) =>
    SystemConfigModel.fromJson(json.decode(str));

String systemConfigModelToJson(SystemConfigModel data) =>
    json.encode(data.toJson());

class SystemConfigModel {
  SystemConfigModel({
    required this.id,
    required this.lowPwm,
    required this.medPwm,
    required this.highpwm,
    required this.lowRpm,
    required this.medRpm,
    required this.highRpm,
    required this.fanFilterCountdown,
    required this.controlMode,
    required this.ecoMode,
    required this.ecoTempDiff,
    required this.ecoOutMinTemp,
    required this.ecoOutMaxTemp,
    required this.ecoOutMaxHum,
    required this.ecoOutMaxMoist,
    required this.ecoOutMaxDew,
    required this.ecoOutMaxEnthalpy,
    required this.ecoEnthalpy,
    required this.ecoCo2P1,
    required this.ecoCo2P2,
    required this.ecoCo2DamperP1,
    required this.ecoCo2DamperP2,
  });

  String id;
  String lowPwm;
  String medPwm;
  String highpwm;
  String lowRpm;
  String medRpm;
  String highRpm;
  String fanFilterCountdown;
  String controlMode;
  String ecoMode;
  String ecoTempDiff;
  String ecoOutMinTemp;
  String ecoOutMaxTemp;
  String ecoOutMaxHum;
  String ecoOutMaxMoist;
  String ecoOutMaxDew;
  String ecoOutMaxEnthalpy;
  String ecoEnthalpy;
  String ecoCo2P1;
  String ecoCo2P2;
  String ecoCo2DamperP1;
  String ecoCo2DamperP2;

  factory SystemConfigModel.fromJson(Map<String, dynamic> json) =>
      SystemConfigModel(
        id: json["id"],
        lowPwm: json["lowPwm"],
        medPwm: json["medPwm"],
        highpwm: json["highpwm"],
        lowRpm: json["lowRpm"],
        medRpm: json["medRpm"],
        highRpm: json["highRpm"],
        fanFilterCountdown: json["fanFilterCountdown"],
        controlMode: json["controlMode"],
        ecoMode: json["ecoMode"],
        ecoTempDiff: json["ecoTempDiff"],
        ecoOutMinTemp: json["ecoOutMinTemp"],
        ecoOutMaxTemp: json["ecoOutMaxTemp"],
        ecoOutMaxHum: json["ecoOutMaxHum"],
        ecoOutMaxMoist: json["ecoOutMaxMoist"],
        ecoOutMaxDew: json["ecoOutMaxDew"],
        ecoOutMaxEnthalpy: json["ecoOutMaxEnthalpy"],
        ecoEnthalpy: json["ecoEnthalpy"],
        ecoCo2P1: json["ecoCo2P1"],
        ecoCo2P2: json["ecoCo2P2"],
        ecoCo2DamperP1: json["ecoCo2DamperP1"],
        ecoCo2DamperP2: json["ecoCo2DamperP2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lowPwm": lowPwm,
        "medPwm": medPwm,
        "highpwm": highpwm,
        "lowRpm": lowRpm,
        "medRpm": medRpm,
        "highRpm": highRpm,
        "fanFilterCountdown": fanFilterCountdown,
        "controlMode": controlMode,
        "ecoMode": ecoMode,
        "ecoTempDiff": ecoTempDiff,
        "ecoOutMinTemp": ecoOutMinTemp,
        "ecoOutMaxTemp": ecoOutMaxTemp,
        "ecoOutMaxHum": ecoOutMaxHum,
        "ecoOutMaxMoist": ecoOutMaxMoist,
        "ecoOutMaxDew": ecoOutMaxDew,
        "ecoOutMaxEnthalpy": ecoOutMaxEnthalpy,
        "ecoEnthalpy": ecoEnthalpy,
        "ecoCo2P1": ecoCo2P1,
        "ecoCo2P2": ecoCo2P2,
        "ecoCo2DamperP1": ecoCo2DamperP1,
        "ecoCo2DamperP2": ecoCo2DamperP2,
      };
}
