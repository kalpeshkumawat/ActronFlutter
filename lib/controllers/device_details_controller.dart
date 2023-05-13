import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/sysops_data_model.dart';

class DeviceDetailsController extends GetxController {
  List searchResult = [].obs;
  List searchList = [];
  var date = DateFormat.yMMMMd('en_US').format(DateTime.now());
  String commissionedDate = '--';

  // device details
  final version = ''.obs;
  final model = ''.obs;
  final serial = ''.obs;
  final oduVersion = ''.obs;
  final iduVersion = ''.obs;
  // pages
  final deviceDetailsPage = true.obs;
  final operationsTillHpPressure = false.obs;
  final operationsTillVsdMotor = false.obs;
  final errorsCodesRegistry = false.obs;
  final errorsDatesRegistry = false.obs;
  final errorsTimesRegistry = false.obs;
  final activeErrorsRegistry = false.obs;
  final economiserSettingPage = false.obs;
  final advancedSearchPage = false.obs;
  final graphPage = false.obs;
  // system operations
  final sysOpsDataLoading = true.obs;
  final statusFlagsData = ''.obs;
  final activeError = ''.obs;
  final operationModeSelectedValue = 0.obs;
  final selectMode = 0.obs;
  final operationMode = ''.obs;
  final systemOperationsData = [
    SystemOperationRegisterModels(
        leading: 'IDU Fan Percentage', reg: 16, type: 'r/w'),
    SystemOperationRegisterModels(leading: 'IDU Fan RPM', reg: 17, type: 'r/w'),
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
    SystemOperationRegisterModels(leading: 'LP Pressure', reg: 2, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'ODU Fan Speed(V/RPM/Relay)', reg: 32, type: 'r'),
    SystemOperationRegisterModels(leading: 'EXV Target', reg: 34, type: 'r/w'),
    SystemOperationRegisterModels(leading: 'EXV Position', reg: 335, type: 'r'),
    SystemOperationRegisterModels(leading: 'ODU State', reg: 36, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'ODU State Time', reg: 37, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Discharge Superheat', reg: 46, type: 'r'),
    SystemOperationRegisterModels(leading: 'Superheat', reg: 47, type: 'r'),
    SystemOperationRegisterModels(leading: 'ODU Fan RPM', reg: 500, type: 'r'),
    SystemOperationRegisterModels(leading: 'Reverse Valve', reg: 32, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Crank Case Heater',
        reg: 32,
        type: 'r/w',
        toggleButton: true,
        bit: 4),
    SystemOperationRegisterModels(
        leading: 'PFC', reg: 32, type: 'r/w', toggleButton: true, bit: 6),
    SystemOperationRegisterModels(leading: 'Fault', reg: 32, type: 'r'),
    SystemOperationRegisterModels(leading: 'Comp Run', reg: 32, type: 'r'),
  ].obs;
  final systemOperationsModesAndSpeeds = [
    SystemOperationRegisterModels(leading: 'Control Mode', reg: 8, type: 'r'),
    SystemOperationRegisterModels(
        leading: 'Operation Mode', reg: 12, type: 'r/w', select: true),
    SystemOperationRegisterModels(
        leading: 'Request Compressor Speed', reg: 11, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Actual Compressor Speed', reg: 13, type: 'r/w'),
  ].obs;
  // monitoring page
  List coilTempGraphData = [].obs;
  List dltTempGraphData = [].obs;
  List sctTempGraphData = [].obs;
  List superheatGraphData = [].obs;
  List exvOpeningGraphData = [].obs;
  List hpPressureGraphData = [].obs;
  List lpPressureGraphData = [].obs;
  List compSpeedGraphData = [].obs;
  // error history
  List errorCodes = [].obs;
  List errorTimes = [].obs;
  List errorDates = [].obs;

  // configuration page
  List systemConfigurationDropdowns = [
    {'heading': 'Control Mode', 'model': 'showControlModel'},
    {'heading': 'Operation Settings', 'model': 'showOperationModel'},
    {'heading': 'Economiser Settings', 'model': 'showEconomiserModel'},
    {'heading': 'Information', 'model': 'showInformationModel'},
  ];
  final economiserSettings = [
    SystemOperationRegisterModels(leading: 'Mode', reg: 450, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Temperature Difference', reg: 451, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Min Temperature', reg: 452, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Temperature', reg: 453, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Humidity', reg: 454, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Moisture', reg: 455, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Dew Point', reg: 456, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Outside Max Enthalpy', reg: 457, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'Enthalpy Delta', reg: 458, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO\u2082 P1', reg: 459, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO\u2082 P2', reg: 460, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO\u2082 DamperP1', reg: 461, type: 'r/w'),
    SystemOperationRegisterModels(
        leading: 'CO\u2082 DamperP2', reg: 462, type: 'r/w'),
  ];

  updateSystemOperationsData(SystemOperationRegisterModels newValue) {
    var operationsData = systemOperationsData.toList();
    for (var element in operationsData) {
      if (element.leading == newValue.leading) {
        element.trailing = newValue.trailing;
      }
    }
    systemOperationsData.assignAll(operationsData);
  }

  updateSystemOperationsModesAndSpeeds(SystemOperationRegisterModels newValue) {
    var operationsModesAndSpeeds = systemOperationsModesAndSpeeds.toList();
    for (var element in operationsModesAndSpeeds) {
      if (element.leading == newValue.leading) {
        element.trailing = newValue.trailing;
      }
    }
    systemOperationsModesAndSpeeds.assignAll(operationsModesAndSpeeds);
  }

  updateEconomiserSettings(SystemOperationRegisterModels newValue) {
    var ecoSettings = economiserSettings.toList();
    for (var element in ecoSettings) {
      if (element.leading == newValue.leading) {
        element.trailing = newValue.trailing;
      }
    }
    economiserSettings.assignAll(ecoSettings);
  }
}
