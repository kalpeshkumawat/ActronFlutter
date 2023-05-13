// import 'package:airlink/common/common_widgets.dart';
// import 'package:airlink/controllers/ble_controller.dart';
// import 'package:airlink/controllers/device_details_controller.dart';
// import 'package:airlink/controllers/system_commission_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../models/device_details_model.dart';
// import '../models/error_model.dart';
// import '../models/system_config_model.dart';
// import '../models/system_operations_model.dart';
// import 'device_table.dart';

// class SqlDbService {
//   final bleController = Get.find<BleController>(tag: 'bleController');
//   final deviceDetailsController =
//       Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
//   final systemConfigurationController =
//       Get.find<SystemConfigurationController>(tag: 'systemConfigurationController');

//   addDeviceToDB() async {
//     try {
//       await DeviceTable.instance.insertDeviceDetails(
//         DeviceDetailsModel(
//             name: bleController.selectedDevice!.name,
//             id: bleController.selectedDevice!.id.toString(),
//             model: deviceDetailsController.model.value,
//             serial: deviceDetailsController.serial.value,
//             type: bleController.selectedDevice!.type.toString(),
//             date: '12/07/2022'),
//       );
//       await DeviceTable.instance.insertSystemOpsDetails(
//         SystemOperationsModel(
//           id: bleController.selectedDevice!.id.toString(),
//           controlMode: deviceDetailsController
//               .systemOperationsModesAndSpeeds[0].trailing
//               .toString(),
//           operationMode: deviceDetailsController
//               .systemOperationsModesAndSpeeds[1].trailing
//               .toString(),
//           requestCompSpeed: deviceDetailsController
//               .systemOperationsModesAndSpeeds[2].trailing
//               .toString(),
//           actualCompSpeed: deviceDetailsController
//               .systemOperationsModesAndSpeeds[3].trailing
//               .toString(),
//           statusFlags: deviceDetailsController.statusFlagsData.value.toString(),
//           iduFanPercent: deviceDetailsController
//               .systemOperationsData[0].trailing
//               .toString(),
//           iduFanRpm: deviceDetailsController.systemOperationsData[1].trailing
//               .toString(),
//           oduFanSpeed: deviceDetailsController.systemOperationsData[2].trailing
//               .toString(),
//           oduFanRpm: deviceDetailsController.systemOperationsData[3].trailing
//               .toString(),
//           iduCoilTemp: deviceDetailsController.systemOperationsData[4].trailing
//               .toString(),
//           oduAmbientTemp: deviceDetailsController
//               .systemOperationsData[5].trailing
//               .toString(),
//           oduCoilTemp: deviceDetailsController.systemOperationsData[6].trailing
//               .toString(),
//           dischargeTemp: deviceDetailsController
//               .systemOperationsData[7].trailing
//               .toString(),
//           suctionTemp: deviceDetailsController.systemOperationsData[8].trailing
//               .toString(),
//           roomTemp: deviceDetailsController.systemOperationsData[9].trailing
//               .toString(),
//           hpPressure: deviceDetailsController.systemOperationsData[10].trailing
//               .toString(),
//           lpPressure: deviceDetailsController.systemOperationsData[11].trailing
//               .toString(),
//           exvTarget: deviceDetailsController.systemOperationsData[12].trailing
//               .toString(),
//           exvPosition: deviceDetailsController.systemOperationsData[13].trailing
//               .toString(),
//           oduState: deviceDetailsController.systemOperationsData[14].trailing
//               .toString(),
//           oduStateTime: deviceDetailsController
//               .systemOperationsData[15].trailing
//               .toString(),
//           superheat: deviceDetailsController.systemOperationsData[16].trailing
//               .toString(),
//           reverseValve: deviceDetailsController
//               .systemOperationsData[17].trailing
//               .toString(),
//           crankCaseHeater: deviceDetailsController
//               .systemOperationsData[18].trailing
//               .toString(),
//           pfc: deviceDetailsController.systemOperationsData[19].trailing
//               .toString(),
//           fault: deviceDetailsController.systemOperationsData[20].trailing
//               .toString(),
//           compRun: deviceDetailsController.systemOperationsData[21].trailing
//               .toString(),
//         ),
//       );
//       await DeviceTable.instance.insertSystemConfigDetails(SystemConfigModel(
//           id: bleController.selectedDevice!.id.toString(),
//           lowPwm: systemConfigurationController.lowPwm.value.text.toString(),
//           medPwm: systemConfigurationController.medPwm.value.text.toString(),
//           highpwm: systemConfigurationController.highPwm.value.text.toString(),
//           lowRpm: systemConfigurationController.lowRpm.value.text.toString(),
//           medRpm: systemConfigurationController.medRpm.value.text.toString(),
//           highRpm: systemConfigurationController.highRpm.value.text.toString(),
//           fanFilterCountdown:
//               systemConfigurationController.fanFilter.value.text.toString(),
//           controlMode:
//               systemConfigurationController.controlModeSelectedValue.toString(),
//           ecoMode:
//               deviceDetailsController.economiserSettings[0].trailing.toString(),
//           ecoTempDiff:
//               deviceDetailsController.economiserSettings[1].trailing.toString(),
//           ecoOutMinTemp:
//               deviceDetailsController.economiserSettings[2].trailing.toString(),
//           ecoOutMaxTemp:
//               deviceDetailsController.economiserSettings[3].trailing.toString(),
//           ecoOutMaxHum:
//               deviceDetailsController.economiserSettings[4].trailing.toString(),
//           ecoOutMaxMoist:
//               deviceDetailsController.economiserSettings[5].trailing.toString(),
//           ecoOutMaxDew:
//               deviceDetailsController.economiserSettings[6].trailing.toString(),
//           ecoOutMaxEnthalpy:
//               deviceDetailsController.economiserSettings[7].trailing.toString(),
//           ecoEnthalpy:
//               deviceDetailsController.economiserSettings[8].trailing.toString(),
//           ecoCo2P1:
//               deviceDetailsController.economiserSettings[9].trailing.toString(),
//           ecoCo2P2: deviceDetailsController.economiserSettings[10].trailing
//               .toString(),
//           ecoCo2DamperP1: deviceDetailsController
//               .economiserSettings[11].trailing
//               .toString(),
//           ecoCo2DamperP2: deviceDetailsController
//               .economiserSettings[12].trailing
//               .toString()));
//       await DeviceTable.instance.insertErrorDetails(
//         DeviceErrorsModel(
//           id: bleController.selectedDevice!.id.toString(),
//           errorCodes: deviceDetailsController.errorCodes.toList(),
//           errorTimes: deviceDetailsController.errorTimes.toList(),
//           errorDates: deviceDetailsController.errorDates.toList(),
//         ),
//       );
//       CommonWidgets().succesSnackbar(title: '', message: 'Saved Successfully');
//     } catch (e) {
//       CommonWidgets()
//           .errorSnackbar(title: '', message: 'Couldn\'t save the device');
//     }
//   }

//   queryDetails() async {
//     var deviceDetailsQuery =
//         await DeviceTable.instance.queryDeviceDetailsRows();
//     var sysOpsQuery = await DeviceTable.instance.querySystemOpsDetails();
//     var sysConfigQuery = await DeviceTable.instance.querySystemConfigDetails();
//     var errorDetailsQuery = await DeviceTable.instance.queryErrorDetails();
//     debugPrint(
//         'device details from table are $deviceDetailsQuery, type of data is ${deviceDetailsQuery.runtimeType}');
//     debugPrint(
//         'device details from table are $sysOpsQuery, type of data is ${sysOpsQuery.runtimeType}');
//     debugPrint(
//         'device details from table are $sysConfigQuery, type of data is ${sysConfigQuery.runtimeType}');
//     debugPrint(
//         'device details from table are $errorDetailsQuery, type of data is ${errorDetailsQuery.runtimeType}');
//   }
// }
