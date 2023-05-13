import 'package:airlink/models/chart_data_model.dart';
import 'package:airlink/models/sysops_data_model.dart';
import 'package:airlink/models/system_config_model.dart';
import 'package:airlink/models/system_operations_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DeviceDetailsController extends GetxController {
  final commissionedDate = ''.obs;
  final lastUpdatedDate = ''.obs;
  List searchResult = [].obs;
  List searchList = [];
  // device details
  final deviceName = TextEditingController().obs;
  final version = ''.obs;
  final model = ''.obs;
  final serial = ''.obs;
  final oduVersion = ''.obs;
  final iduVersion = ''.obs;
  final date = ''.obs;
  // pages
  final deviceDetailsPage = true.obs;
  final systemOperationsPage = false.obs;
  final noErrorsRegistry = false.obs;
  final errorsCodesRegistry = false.obs;
  final errorsDatesRegistry = false.obs;
  final errorsTimesRegistry = false.obs;
  final activeErrorsRegistry = false.obs;
  final systemConfigurePage = false.obs;
  final advancedSearchPage = false.obs;
  final graphPage = false.obs;
  // system operations
  final sysOpsDataLoading = true.obs;
  final statusFlagsData = ''.obs;
  final activeError = ''.obs;
  final operationModeSelectedValue = 0.obs;
  final operationMode = ''.obs;
  final operationModeFanMode = 0.obs;
  final systemModesLeading = [
    SystemOperationRegisterModels(leading: 'Control Mode', reg: 8, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Operation Mode', reg: 12, type: 'r/w', select: true),
    SystemOperationRegisterModels(
        leading: 'Request Compressor Speed', reg: 11, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Actual Compressor Speed', reg: 13, type: 'r/w'),
  ].obs;
  final systemOperationsLeading = [
    SystemOperationRegisterModels(
        leading: 'IDU Fan Percentage', reg: 16, type: 'r/w'),
    SystemOperationRegisterModels(leading: 'IDU Fan RPM', reg: 17, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'ODU Fan Speed(V/RPM/Relay)', reg: 32, type: 'r'),
    SystemOperationRegisterModels(leading: 'ODU Fan RPM', reg: 500, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'IDU Coil Temperature', reg: 18, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'ODU Ambient Temperature', reg: 20, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'ODU Coil Temperature', reg: 21, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Discharge Temperature', reg: 24, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Suction Temperature', reg: 25, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Room Temperature', reg: 93, type: 'r'),
    SystemOperationRegisterModels(leading: 'HP Pressure', reg: 26, type: 'r'),
    SystemOperationRegisterModels(leading: 'LP Pressure', reg: 27, type: 'r'),
    SystemOperationRegisterModels(leading: 'EXV Target', reg: 34, type: 'r/w'),
    SystemOperationRegisterModels(leading: 'EXV Position', reg: 35, type: 'r'),
    SystemOperationRegisterModels(leading: 'ODU State', reg: 36, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'ODU State Time', reg: 37, type: 'r'),
    SystemOperationRegisterModels(leading: 'Superheat', reg: 47, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Discharge Superheat', reg: 46, type: 'r'),
    SystemOperationRegisterModels(leading: 'Reverse Valve', reg: 32, type: 'r'),
    SystemOperationRegisterModels(
      leading: 'Crank Case Heater',
      reg: 32,
      type: 'r/w',
      toggleButton: true,
      bit: 4,
    ),
    SystemOperationRegisterModels(
        leading: 'PFC', reg: 32, type: 'r/w', toggleButton: true, bit: 6),
    SystemOperationRegisterModels(leading: 'Fault', reg: 32, type: 'r'),
    SystemOperationRegisterModels(leading: 'Comp Run', reg: 32, type: 'r'),
  ].obs;
  final systemOperationsData = SystemOperationsModel(
          id: '--',
          controlMode: '--',
          operationMode: '--',
          requestCompSpeed: '--',
          actualCompSpeed: '--',
          statusFlags: '--',
          iduFanPercentage: '--',
          iduFanRpm: '--',
          oduFanSpeed: '--',
          oduFanRpm: '--',
          iduCoilTemp: '--',
          oduAmbientTemp: '--',
          oduCoilTemp: '--',
          dischargeTemp: '--',
          suctionTemp: '--',
          roomTemp: '--',
          hpPressure: '--',
          lpPressure: '--',
          exvTarget: '--',
          exvPosition: '--',
          oduState: '--',
          oduStateTime: '--',
          superheat: '--',
          dischargeSuperheat: '--',
          reverseValve: '--',
          crankCaseHeater: '--',
          pfc: '--',
          fault: '--',
          compRun: '--')
      .obs;
  updateSystemOpsData(SystemOperationsModel data) {
    systemOperationsData.update((val) {
      val?.id = data.id;
      val?.controlMode = data.controlMode;
      val?.operationMode = data.operationMode;
      val?.requestCompSpeed = data.requestCompSpeed;
      val?.actualCompSpeed = data.actualCompSpeed;
      val?.statusFlags = data.statusFlags;
      val?.iduFanPercentage = data.iduFanPercentage;
      val?.iduFanRpm = data.iduFanRpm;
      val?.oduFanSpeed = data.oduFanSpeed;
      val?.oduFanRpm = data.oduFanRpm;
      val?.iduCoilTemp = data.iduCoilTemp;
      val?.oduAmbientTemp = data.oduAmbientTemp;
      val?.oduCoilTemp = data.oduCoilTemp;
      val?.dischargeTemp = data.dischargeTemp;
      val?.suctionTemp = data.suctionTemp;
      val?.roomTemp = data.roomTemp;
      val?.hpPressure = data.hpPressure;
      val?.lpPressure = data.lpPressure;
      val?.exvTarget = data.exvTarget;
      val?.exvPosition = data.exvPosition;
      val?.oduState = data.oduState;
      val?.oduStateTime = data.oduStateTime;
      val?.superheat = data.superheat;
      val?.dischargeSuperheat = data.dischargeSuperheat;
      val?.reverseValve = data.reverseValve;
      val?.crankCaseHeater = data.crankCaseHeater;
      val?.pfc = data.pfc;
      val?.fault = data.fault;
      val?.compRun = data.compRun;
    });
  }

  // monitoring page
  List coilTempGraphData = [].obs;
  List dltTempGraphData = [].obs;
  List sctTempGraphData = [].obs;
  List superheatGraphData = [].obs;
  List exvOpeningGraphData = [].obs;
  List hpPressureGraphData = [].obs;
  List lpPressureGraphData = [].obs;
  List compSpeedGraphData = [].obs;
  List<ChartData> wholeChartData = [];
  // error history
  List errorCodes = [].obs;
  List errorTimes = [].obs;
  List errorDates = [].obs;
  List noErrorCodes = [].obs;
  final isNoErrors = false.obs;

  // configuration page
  List systemCommissionDropdowns = [
    {'heading': 'Control Mode', 'model': 'showControlModel'},
    {'heading': 'Operation Settings', 'model': 'showOperationModel'},
    {'heading': 'Economiser Settings', 'model': 'showEconomiserModel'},
    {'heading': 'Information', 'model': 'showInformationModel'},
  ];
  final economiserSettings = SystemConfigModel(
          ecoMode: '--',
          ecoTempDiff: '--',
          ecoOutMinTemp: '--',
          ecoOutMaxTemp: '--',
          ecoOutMaxHum: '--',
          ecoOutMaxMoist: '--',
          ecoOutMaxDew: '--',
          ecoOutMaxEnthalpy: '--',
          ecoEnthalpy: '--',
          ecoCo2P1: '--',
          ecoCo2P2: '--',
          ecoCo2DamperP1: '--',
          ecoCo2DamperP2: '--')
      .obs;

  final economiserLeading = [
    SystemOperationRegisterModels(leading: ' Mode', reg: 450, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: ' Temperature Difference', reg: 451, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: ' Outside Min Temperature', reg: 452, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: ' Outside Max Temperature', reg: 453, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: ' Outside Max Humidity', reg: 454, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Moisture', reg: 455, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Dew Point', reg: 456, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Enthalpy', reg: 457, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Enthalpy Delta', reg: 458, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO \u2082 P1', reg: 459, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO \u2082 P2', reg: 460, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO \u2082 DamperP1', reg: 461, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO \u2082 DamperP2', reg: 462, type: 'r/w'),
  ].obs;

  updateEconomiserSettings(SystemConfigModel data) {
    economiserSettings.update((val) {
      val?.ecoMode = data.ecoMode;
      val?.ecoTempDiff = data.ecoTempDiff;
      val?.ecoOutMinTemp = data.ecoOutMinTemp;
      val?.ecoOutMaxTemp = data.ecoOutMaxTemp;
      val?.ecoOutMaxHum = data.ecoOutMaxHum;
      val?.ecoOutMaxMoist = data.ecoOutMaxMoist;
      val?.ecoOutMaxDew = data.ecoOutMaxDew;
      val?.ecoOutMaxEnthalpy = data.ecoOutMaxEnthalpy;
      val?.ecoEnthalpy = data.ecoEnthalpy;
      val?.ecoCo2P1 = data.ecoCo2P1;
      val?.ecoCo2P2 = data.ecoCo2P2;
      val?.ecoCo2DamperP1 = data.ecoCo2DamperP1;
      val?.ecoCo2DamperP2 = data.ecoCo2DamperP2;
    });
  }
}
