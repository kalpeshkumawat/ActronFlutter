import 'dart:convert';

SystemConfigModel systemConfigModelFromJson(String str) =>
    SystemConfigModel.fromJson(json.decode(str));

String systemConfigModelToJson(SystemConfigModel data) =>
    json.encode(data.toJson());

class SystemConfigModel {
  SystemConfigModel({
    this.id,
    this.lowPwm,
    this.medPwm,
    this.highPwm,
    this.lowRpm,
    this.medRpm,
    this.highRpm,
    this.fanFilterCountdown,
    this.controlMode,
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

  String? id;
  String? lowPwm;
  String? medPwm;
  String? highPwm;
  String? lowRpm;
  String? medRpm;
  String? highRpm;
  String? fanFilterCountdown;
  String? controlMode;
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
        highPwm: json["highPwm"],
        lowRpm: json["lowRpm"],
        medRpm: json["medRpm"],
        highRpm: json["highRpm"],
        fanFilterCountdown: json["fanFilterCountdown"],
        controlMode: json["controlMode"],
        ecoMode: json["economiserMode"],
        ecoTempDiff: json["economiserTemperatureDifference"],
        ecoOutMinTemp: json["economiserOutsideMinTemperature"],
        ecoOutMaxTemp: json["economiserOutsideMaxTemperature"],
        ecoOutMaxHum: json["economiserOutsideMaxHumidity"],
        ecoOutMaxMoist: json["economiserOutsideMaxMoisture"],
        ecoOutMaxDew: json["economiserOutsideMaxDewPoint"],
        ecoOutMaxEnthalpy: json["economiserOutsideMaxEnthalpy"],
        ecoEnthalpy: json["economiserEnthalpyDelta"],
        ecoCo2P1: json["economiserCO2P1"],
        ecoCo2P2: json["economiserCO2P2"],
        ecoCo2DamperP1: json["economiserCO2DamperP1"],
        ecoCo2DamperP2: json["economiserCO2DamperP2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lowPwm": lowPwm,
        "medPwm": medPwm,
        "highPwm": highPwm,
        "lowRpm": lowRpm,
        "medRpm": medRpm,
        "highRpm": highRpm,
        "fanFilterCountdown": fanFilterCountdown,
        "controlMode": controlMode,
        "economiserMode": ecoMode,
        "economiserTemperatureDifference": ecoTempDiff,
        "economiserOutsideMinTemperature": ecoOutMinTemp,
        "economiserOutsideMaxTemperature": ecoOutMaxTemp,
        "economiserOutsideMaxHumidity": ecoOutMaxHum,
        "economiserOutsideMaxMoisture": ecoOutMaxMoist,
        "economiserOutsideMaxDewPoint": ecoOutMaxDew,
        "economiserOutsideMaxEnthalpy": ecoOutMaxEnthalpy,
        "economiserEnthalpyDelta": ecoEnthalpy,
        "economiserCO2P1": ecoCo2P1,
        "economiserCO2P2": ecoCo2P2,
        "economiserCO2DamperP1": ecoCo2DamperP1,
        "economiserCO2DamperP2": ecoCo2DamperP2,
      };
}
