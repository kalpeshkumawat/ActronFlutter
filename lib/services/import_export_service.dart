import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'db_service.dart';

class ImportExportService {
  final bleController = Get.find<BleController>(tag: 'bleController');

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
    dynamic requiredDevice;
    var savedDevices = await DbService().readStringList('devices');

    if (savedDevices != null) {
      for (var device in savedDevices) {
        var jsonFormattedDevice = jsonDecode(jsonDecode(
          jsonEncode(device),
        ));
        if ((jsonFormattedDevice['id']) == selectedId) {
          requiredDevice = device;
          inspect(requiredDevice);
        }
      }
      if (requiredDevice == null) {
        debugPrint('nothing found');
        return;
      } else {
        var file = await readFile();
        debugPrint('file while exporting is ${await file}');
        final Email email = Email(
          body: 'Email body',
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
    } else {
      debugPrint('nothing found');
      return;
    }
  }
}
