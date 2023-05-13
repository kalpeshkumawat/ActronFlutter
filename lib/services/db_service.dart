import 'dart:convert';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/services/import_export_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/device_details_controller.dart';

class DbService {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.put(DeviceDetailsController(), tag: 'deviceDetailsController');
  writeStringData(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  readStringData(key) async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString(key);
    return accessToken;
  }

  readStringList(key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList(key);
    return data;
  }

  deleteString(data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(data);
  }

  writeListString(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }

  getSavedDevices(deviceDetials) async {
    var savedDevice = await DbService().readStringList('devices');
    print('saved devices are $savedDevice');
    bleController.savedDevices.clear();
    if (savedDevice != null) {
      for (var i = 0; i < savedDevice.length; i++) {
        var device = jsonDecode(
          jsonEncode(
            savedDevice[i],
          ),
        );
        deviceDetials.add(device);
        var deviceDetailsJson = jsonDecode(((deviceDetials[i])));

        bleController.savedDevices.add(deviceDetailsJson);
        bleController.localBluetoothDevices.add(BluetoothDevice.fromId(
          bleController.savedDevices[i]['id'],
          name: bleController.savedDevices[i]['name'],
          type: BluetoothDeviceType.values[int.parse(
            bleController.savedDevices[i]['type'],
          )],
        ));
      }
    }
  }

  saveDeviceAfterDeletion(devices) {
    List<String> newDevices = [];
    var device = (jsonEncode(devices[0]));
    debugPrint(
        'devices param is $devices, device non param is ${devices.runtimeType}');
    newDevices.add(device);
    debugPrint(
        'devices before adding to data base in saveDeviceAfterDelation ${newDevices[0].runtimeType}');
    writeListString('devices', newDevices);
  }

  saveDevice(device, import) async {
    try {
      List<String> newDevice = [];
      var devicesInLoacalStorage = await DbService().readStringList('devices');
      debugPrint('local storage devices $devicesInLoacalStorage');
      var date = (DateTime.now());
      var deviceFormat;
      if (devicesInLoacalStorage != null) {
        var deviceDetails = jsonDecode(
          jsonEncode(devicesInLoacalStorage),
        ).cast<String>();
        debugPrint('devies in save device param is  $device');
        if (import) {
          deviceFormat = (device);
        } else {
          deviceFormat = deviceStoringFormat(device, date);
        }
        deviceDetails.add(deviceFormat);
        debugPrint(
            'formateed device before saving to database is $deviceDetails');
        writeListString('devices', deviceDetails);
      } else {
        if (import) {
          deviceFormat = (device);
        } else {
          deviceFormat = deviceStoringFormat(device, date);
        }
        newDevice.add((deviceFormat));
        await ImportExportService().writeDevice(newDevice.toString());
        writeListString(
          'devices',
          newDevice,
        );
      }
      CommonWidgets().succesSnackbar(
        title: "",
        message: "Device saved successfully",
      );
    } catch (e) {
      debugPrint(e.toString());
      CommonWidgets().errorSnackbar(title: "", message: e.toString());
    }
  }

  deviceStoringFormat(device, date) {
    debugPrint(
        'type of device for storing is ${device.runtimeType.toString()}');
    var systemOperationsData = [];
    var systemOperationsModesAndSpeeds = [];
    var errorCodes = [];
    var errorTimes = [];
    var errorDates = [];
    for (var element
        in deviceDetailsController.systemOperationsModesAndSpeeds) {
      systemOperationsModesAndSpeeds
          .add(('{\'${element.leading}\': \'${element.trailing}\'}'));
    }
    for (var element in deviceDetailsController.systemOperationsData) {
      debugPrint(
          'element ${element.leading} : ${element.trailing}');

      systemOperationsData
          .add(('{\'${element.leading}\': \'${element.trailing}\'}'));
    }
    debugPrint('adding errors');
    if (deviceDetailsController.errorCodes.isNotEmpty) {
      for (var i = 0; i < 2; i++) {
        errorCodes.add((deviceDetailsController.errorCodes[i]));
        errorTimes.add(deviceDetailsController.errorTimes[i]);
        errorDates.add(deviceDetailsController.errorDates[i]);
      }
    }
    var devicesFormat = '''{
      \"id\": \"${device.id.toString()}\",
      \"version\": \"${deviceDetailsController.version}\",
      \"name\": \"${device.name}\",
      \"type\": \"${device.type.index}\",
      \"date\": \"$date\",
      \"commissionedDate\": \"${deviceDetailsController.commissionedDate}\",
      \"model\": \"${deviceDetailsController.model}\",
      \"serial\": \"${deviceDetailsController.serial}\",
      \"iduVersion\": \"${deviceDetailsController.iduVersion}\",
      \"oduVersion\": \"${deviceDetailsController.oduVersion}\",
      \"systemOperations\": \"$systemOperationsData\",
      \"systemOperationsModesAndSpeeds\": \"$systemOperationsModesAndSpeeds\",
      \"errorCodes\": \"$errorCodes\",
      \"errorTimes\": \"$errorTimes\",
      \"errorDates\": \"$errorDates\"
    }''';
    return devicesFormat;
  }
}
