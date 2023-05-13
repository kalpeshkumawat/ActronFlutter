import 'dart:convert';

SystemOperationsModel systemOperationsModelFromMap(String str) =>
    SystemOperationsModel.fromJson(json.decode(str));

String systemOperationsModelToMap(SystemOperationsModel data) =>
    json.encode(data.toJson());

class SystemOperationsModel {
  SystemOperationsModel({
    required this.id,
    required this.controlMode,
    required this.operationMode,
    required this.requestCompSpeed,
    required this.actualCompSpeed,
    required this.statusFlags,
    required this.iduFanPercentage,
    required this.iduFanRpm,
    required this.oduFanSpeed,
    required this.oduFanRpm,
    required this.iduCoilTemp,
    required this.oduAmbientTemp,
    required this.oduCoilTemp,
    required this.dischargeTemp,
    required this.suctionTemp,
    required this.roomTemp,
    required this.hpPressure,
    required this.lpPressure,
    required this.exvTarget,
    required this.exvPosition,
    required this.oduState,
    required this.oduStateTime,
    required this.superheat,
    required this.dischargeSuperheat,
    required this.reverseValve,
    required this.crankCaseHeater,
    required this.pfc,
    required this.fault,
    required this.compRun,
  });

  String id;
  String controlMode;
  String operationMode;
  String requestCompSpeed;
  String actualCompSpeed;
  String statusFlags;
  String iduFanPercentage;
  String iduFanRpm;
  String oduFanSpeed;
  String oduFanRpm;
  String iduCoilTemp;
  String oduAmbientTemp;
  String oduCoilTemp;
  String dischargeTemp;
  String suctionTemp;
  String roomTemp;
  String hpPressure;
  String lpPressure;
  String exvTarget;
  String exvPosition;
  String oduState;
  String oduStateTime;
  String superheat;
  String dischargeSuperheat;
  String reverseValve;
  String crankCaseHeater;
  String pfc;
  String fault;
  String compRun;

  factory SystemOperationsModel.fromJson(Map<String, dynamic> json) =>
      SystemOperationsModel(
        id: json["id"],
        controlMode: json["controlMode"],
        operationMode: json["operationMode"],
        requestCompSpeed: json["requestCompSpeed"],
        actualCompSpeed: json["actualCompSpeed"],
        statusFlags: json["statusFlags"],
        iduFanPercentage: json["iduFanPercentage"],
        iduFanRpm: json["iDUFanRpm"],
        oduFanSpeed: json["oduFanSpeed"],
        oduFanRpm: json["oduFanRpm"],
        iduCoilTemp: json["iduCoilTemperature"],
        oduAmbientTemp: json["oduAmbientTemperature"],
        oduCoilTemp: json["oduCoilTemperature"],
        dischargeTemp: json["dischargeTemperature"],
        suctionTemp: json["suctionTemperature"],
        roomTemp: json["roomTemperature"],
        hpPressure: json["hpPressure"],
        lpPressure: json["lpPressure"],
        exvTarget: json["exvTarget"],
        exvPosition: json["exvPosition"],
        oduState: json["oduState"],
        oduStateTime: json["oduStateTime"],
        superheat: json["superheat"],
        dischargeSuperheat: json["dischargeSuperheat"],
        reverseValve: json["reverseValve"],
        crankCaseHeater: json["crankCaseHeater"],
        pfc: json["pfc"],
        fault: json["fault"],
        compRun: json["compRun"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "controlMode": controlMode,
        "operationMode": operationMode,
        "requestCompSpeed": requestCompSpeed,
        "actualCompSpeed": actualCompSpeed,
        "statusFlags": statusFlags,
        "iduFanPercentage": iduFanPercentage,
        "iduFanRpm": iduFanRpm,
        "oduFanSpeed": oduFanSpeed,
        "oduFanRpm": oduFanRpm,
        "iduCoilTemperature": iduCoilTemp,
        "oduAmbientTemperature": oduAmbientTemp,
        "oduCoilTemperature": oduCoilTemp,
        "dischargeTemperature": dischargeTemp,
        "suctionTemperature": suctionTemp,
        "roomTemperature": roomTemp,
        "hpPressure": hpPressure,
        "lpPressure": lpPressure,
        "exvTarget": exvTarget,
        "exvPosition": exvPosition,
        "oduState": oduState,
        "oduStateTime": oduStateTime,
        "superheat": superheat,
        "dischargeSuperheat": dischargeSuperheat,
        "reverseValve": reverseValve,
        "crankCaseHeater": crankCaseHeater,
        "pfc": pfc,
        "fault": fault,
        "compRun": compRun,
      };
  int length() {
    Map data = toJson();
    return data.keys.length;
  }
}
