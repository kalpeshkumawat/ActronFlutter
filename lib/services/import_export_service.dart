import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/services/device_db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ImportExportService {
  static final ImportExportService _importExportService =
      ImportExportService._internal();

  factory ImportExportService() {
    return _importExportService;
  }

  ImportExportService._internal();
  final bleController = Get.find<BleController>(tag: 'bleController');
  final homeController = Get.find<HomeController>(tag: 'homeController');

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final root = await localPath;
    final path = '$root/devices.txt';
    return File(path).create(recursive: true);
  }

  Future<File> writeDevice(data) async {
    final file = await localFile;
    try {
      file.open();
      await file.writeAsString(data.toString());
      debugPrint('stored file is $file');

      return file;
    } catch (e) {
      debugPrint('error while writing to file is ${e.toString()}');
      CommonWidgets().errorSnackbar(
        title: '',
        message: "Couldn't write to file",
      );
    }
    return file;
  }

  Future readFile() async {
    try {
      final file = await localFile;
      return file.path;
    } catch (e) {
      CommonWidgets().errorSnackbar(
        title: '',
        message: 'Something went wrong in reading file, try again',
      );
    }
  }

  Future importDataFromFile(file) async {
    try {
      final data = await file.readAsString();
      debugPrint('data is ${data.runtimeType}');
      return data;
    } catch (e) {
      CommonWidgets().errorSnackbar(
        title: "",
        message: "Something went wrong in reading file data, try again",
      );
    }
  }

  exportDataToMail(selectedId) async {
    var deviceData = [];
    for (var element in homeController.savedDevices) {
      if (element.id == selectedId) {
        deviceData.add(element.toJson());
      }
    }
    for (var element in homeController.deviceSystemOperationsData) {
      if (element.id == selectedId) {
        deviceData.add(element.toJson());
      }
    }
    for (var element in homeController.deviceSystemConfigData) {
      if (element.id == selectedId) {
        deviceData.add(element.toJson());
      }
    }
    for (var element in homeController.deviceErrorData) {
      if (element.id == selectedId) {
        deviceData.add(element.toJson());
      }
    }
    writeDevice(deviceData);

    if (deviceData.isEmpty) {
      debugPrint('nothing found');
      return;
    } else {
      var file = await readFile();
      debugPrint('file while exporting is ${await file}');
      final Email email = Email(
        body: ' This contains $selectedId details',
        subject: 'Device Details',
        recipients: ['example@example.com'],
        attachmentPaths: [
          await file,
        ],
        isHTML: false,
      );
      debugPrint('file is ${await readFile()}');
      try {
        await FlutterEmailSender.send(email);
        CommonWidgets()
            .succesSnackbar(title: "", message: "Email sent successfully");
      } catch (e) {
        CommonWidgets().errorSnackbar(
            title: "", message: "Couldn't send email, Please try again");
      }
    }
  }
}
