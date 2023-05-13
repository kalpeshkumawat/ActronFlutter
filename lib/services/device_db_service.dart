import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/table_names_controller.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/controllers/system_configuration_controller.dart';
import 'package:airlink/services/sql_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/device_details_model.dart';
import '../models/error_model.dart';
import '../models/system_config_model.dart';
import '../models/system_operations_model.dart';

class DeviceDbService {
  static final DeviceDbService _deviceDbService = DeviceDbService._internal();

  factory DeviceDbService() {
    return _deviceDbService;
  }

  DeviceDbService._internal();
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.put(DeviceDetailsController(), tag: 'deviceDetailsController');
  final systemConfigurationController = Get.put(SystemConfigurationController(),
      tag: 'systemConfigurationController');
  final homeController = Get.find<HomeController>(tag: 'homeController');
  var isAlreadyPresent = false;

  addDeviceToDB() async {
    var lastUpdatedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
    var comissionedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
    await queryDeviceDetails();
    for (var element in homeController.savedDevices) {
      if (element.id == bleController.selectedDevice!.id.toString()) {
        isAlreadyPresent = true;
        comissionedDate = element.comissionedDate;
        lastUpdatedDate = element.lastUpdatedDate;
      } else {
        isAlreadyPresent = false;
      }
    }

    if (isAlreadyPresent) {
      await SqlService.instance.deleteData(
        tableName: TableNamesController.deviceTable,
        columnToCheck: 'id',
        arugumentNeededForDeletion: bleController.selectedDevice!.id.toString(),
      );
      await SqlService.instance.deleteData(
        tableName: TableNamesController.sysOpsTable,
        columnToCheck: 'id',
        arugumentNeededForDeletion: bleController.selectedDevice!.id.toString(),
      );
      await SqlService.instance.deleteData(
        tableName: TableNamesController.sysConfigTable,
        columnToCheck: 'id',
        arugumentNeededForDeletion: bleController.selectedDevice!.id.toString(),
      );
      await SqlService.instance.deleteData(
        tableName: TableNamesController.errorsTable,
        columnToCheck: 'id',
        arugumentNeededForDeletion: bleController.selectedDevice!.id.toString(),
      );
    }
    try {
      await SqlService.instance.insertData(
        tableName: TableNamesController.deviceTable,
        insertingData: DeviceDetailsModel(
            name: deviceDetailsController.deviceName.value.text,
            id: bleController.selectedDevice!.id.toString(),
            model: deviceDetailsController.model.value,
            serial: deviceDetailsController.serial.value,
            iduVersion: deviceDetailsController.iduVersion.value,
            oduVersion: deviceDetailsController.oduVersion.value,
            type: bleController.selectedDevice!.type.index,
            comissionedDate: comissionedDate,
            lastUpdatedDate: lastUpdatedDate),
      );
      await SqlService.instance.insertData(
        tableName: TableNamesController.sysOpsTable,
        insertingData: SystemOperationsModel(
          id: bleController.selectedDevice!.id.toString(),
          controlMode: deviceDetailsController
              .systemOperationsData.value.controlMode
              .toString(),
          operationMode: deviceDetailsController
              .systemOperationsData.value.operationMode
              .toString(),
          requestCompSpeed: deviceDetailsController
              .systemOperationsData.value.requestCompSpeed
              .toString(),
          actualCompSpeed: deviceDetailsController
              .systemOperationsData.value.actualCompSpeed
              .toString(),
          statusFlags: deviceDetailsController
              .systemOperationsData.value.statusFlags
              .toString(),
          iduFanPercentage: deviceDetailsController
              .systemOperationsData.value.iduFanPercentage
              .toString(),
          iduFanRpm: deviceDetailsController
              .systemOperationsData.value.iduFanRpm
              .toString(),
          oduFanSpeed: deviceDetailsController
              .systemOperationsData.value.oduFanSpeed
              .toString(),
          oduFanRpm: deviceDetailsController
              .systemOperationsData.value.oduFanRpm
              .toString(),
          iduCoilTemp: deviceDetailsController
              .systemOperationsData.value.iduCoilTemp
              .toString(),
          oduAmbientTemp: deviceDetailsController
              .systemOperationsData.value.oduAmbientTemp
              .toString(),
          oduCoilTemp: deviceDetailsController
              .systemOperationsData.value.oduCoilTemp
              .toString(),
          dischargeTemp: deviceDetailsController
              .systemOperationsData.value.dischargeTemp
              .toString(),
          suctionTemp: deviceDetailsController
              .systemOperationsData.value.suctionTemp
              .toString(),
          roomTemp: deviceDetailsController.systemOperationsData.value.roomTemp
              .toString(),
          hpPressure: deviceDetailsController
              .systemOperationsData.value.hpPressure
              .toString(),
          lpPressure: deviceDetailsController
              .systemOperationsData.value.lpPressure
              .toString(),
          exvTarget: deviceDetailsController
              .systemOperationsData.value.exvTarget
              .toString(),
          exvPosition: deviceDetailsController
              .systemOperationsData.value.exvPosition
              .toString(),
          oduState: deviceDetailsController.systemOperationsData.value.oduState
              .toString(),
          oduStateTime: deviceDetailsController
              .systemOperationsData.value.oduStateTime
              .toString(),
          superheat: deviceDetailsController
              .systemOperationsData.value.superheat
              .toString(),
          dischargeSuperheat: deviceDetailsController
              .systemOperationsData.value.dischargeSuperheat,
          reverseValve: deviceDetailsController
              .systemOperationsData.value.reverseValve
              .toString(),
          crankCaseHeater: deviceDetailsController
              .systemOperationsData.value.crankCaseHeater
              .toString(),
          pfc:
              deviceDetailsController.systemOperationsData.value.pfc.toString(),
          fault: deviceDetailsController.systemOperationsData.value.fault
              .toString(),
          compRun: deviceDetailsController.systemOperationsData.value.compRun
              .toString(),
        ),
      );
      await SqlService.instance.insertData(
        tableName: TableNamesController.sysConfigTable,
        insertingData: SystemConfigModel(
          id: bleController.selectedDevice!.id.toString(),
          lowPwm: systemConfigurationController.lowPwm.value.text.toString(),
          medPwm: systemConfigurationController.medPwm.value.text.toString(),
          highPwm: systemConfigurationController.highPwm.value.text.toString(),
          lowRpm: systemConfigurationController.lowRpm.value.text.toString(),
          medRpm: systemConfigurationController.medRpm.value.text.toString(),
          highRpm: systemConfigurationController.highRpm.value.text.toString(),
          fanFilterCountdown:
              systemConfigurationController.fanFilter.value.text.toString(),
          controlMode:
              systemConfigurationController.controlModeSelectedValue.toString(),
          ecoMode: deviceDetailsController.economiserSettings.value.ecoMode
              .toString(),
          ecoTempDiff: deviceDetailsController
              .economiserSettings.value.ecoTempDiff
              .toString(),
          ecoOutMinTemp: deviceDetailsController
              .economiserSettings.value.ecoOutMinTemp
              .toString(),
          ecoOutMaxTemp: deviceDetailsController
              .economiserSettings.value.ecoOutMaxTemp
              .toString(),
          ecoOutMaxHum: deviceDetailsController
              .economiserSettings.value.ecoOutMaxHum
              .toString(),
          ecoOutMaxMoist: deviceDetailsController
              .economiserSettings.value.ecoOutMaxMoist
              .toString(),
          ecoOutMaxDew: deviceDetailsController
              .economiserSettings.value.ecoOutMaxDew
              .toString(),
          ecoOutMaxEnthalpy: deviceDetailsController
              .economiserSettings.value.ecoOutMaxEnthalpy
              .toString(),
          ecoEnthalpy: deviceDetailsController
              .economiserSettings.value.ecoEnthalpy
              .toString(),
          ecoCo2P1: deviceDetailsController.economiserSettings.value.ecoCo2P1
              .toString(),
          ecoCo2P2: deviceDetailsController.economiserSettings.value.ecoCo2P2
              .toString(),
          ecoCo2DamperP1: deviceDetailsController
              .economiserSettings.value.ecoCo2DamperP1
              .toString(),
          ecoCo2DamperP2: deviceDetailsController
              .economiserSettings.value.ecoCo2DamperP2
              .toString(),
        ),
      );
      await SqlService.instance.insertData(
        tableName: TableNamesController.errorsTable,
        insertingData: DeviceErrorsModel(
          id: bleController.selectedDevice!.id.toString(),
          errorCodes: deviceDetailsController.errorCodes.toList(),
          errorTimes: deviceDetailsController.errorTimes.toList(),
          errorDates: deviceDetailsController.errorDates.toList(),
        ),
      );
      CommonWidgets().succesSnackbar(title: '', message: 'Saved Successfully');
    } catch (e) {
      debugPrint('error while saving is ${e.toString()}');
      CommonWidgets()
          .errorSnackbar(title: '', message: 'Couldn\'t save the device');
    }
  }

  queryDeviceDetails() async {
    var deviceDetailsQuery = await SqlService.instance
        .readData(tableName: TableNamesController.deviceTable);
    var sysOpsQuery = await SqlService.instance
        .readData(tableName: TableNamesController.sysOpsTable);
    var sysConfigQuery = await SqlService.instance
        .readData(tableName: TableNamesController.sysConfigTable);
    var errorDetailsQuery = await SqlService.instance
        .readData(tableName: TableNamesController.errorsTable);

    homeController.clearAllData();
    print('Device details are $deviceDetailsQuery');
    print('sys ops data $sysOpsQuery');
    print('sys ops data $sysConfigQuery');
    print('sys ops data $errorDetailsQuery');

    //  deviceDetails
    for (var i = 0; i < deviceDetailsQuery.length; i++) {
      debugPrint('data in device detailstable is ${deviceDetailsQuery[i]}');
      homeController.savedDevices.add(
        DeviceDetailsModel.fromJson(
          deviceDetailsQuery[i],
        ),
      );
      // creating bluetooth device
      bleController.localBluetoothDevices.add(
        BluetoothDevice.fromId(
          homeController.savedDevices[i].id,
          name: homeController.savedDevices[i].name,
          type:
              BluetoothDeviceType.values[(homeController.savedDevices[i].type)],
        ),
      );
    }

    // system operation data
    for (var element in sysOpsQuery) {
      homeController.deviceSystemOperationsData.add(
        SystemOperationsModel.fromJson(element),
      );
    }
    // system config data
    for (var i = 0; i < sysConfigQuery.length; i++) {
      homeController.deviceSystemConfigData.add(
        SystemConfigModel.fromJson(
          sysConfigQuery[i],
        ),
      );
    }

    // error data
    for (var element in errorDetailsQuery) {
      homeController.deviceErrorData.add(
        DeviceErrorsModel.fromJson(element),
      );
      homeController.errorCodes.add(
        DeviceErrorsModel.fromJson(element).errorCodes,
      );
      homeController.errorDates.add(
        DeviceErrorsModel.fromJson(element).errorDates,
      );
      homeController.errorTimes.add(
        DeviceErrorsModel.fromJson(element).errorTimes,
      );
    }

    return deviceDetailsQuery;
  }
}
