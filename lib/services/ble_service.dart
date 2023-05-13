import 'dart:async';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locator;
import '../controllers/ble_controller.dart';
import 'device_details_service.dart';

class BleService {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final bleController = Get.find<BleController>(tag: 'bleController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');

  scanDevice() async {
    bleController.scanComplete.value = false;
    await flutterBlue.startScan(
      timeout: const Duration(seconds: 4),
    );
    //   .whenComplete(
    // () async {
    // bleController.scanComplete.value = true;
    bleController.isRescan.value = false;
    flutterBlue.scanResults.listen(
      (List<ScanResult> devices){
        for (ScanResult result in devices) {
          if (result.device.name.contains('Actron')) {
             bleController.isRescan.value = false;
            if (bleController.devicesFound.isEmpty) {
              bleController.addDevices(result.device);
            } else {
              var sameDevice = bleController.devicesFound
                  .where((element) => element.name == result.device.name);
              if (sameDevice.isEmpty) {
                bleController.addDevices(result.device);
              }
            }
          }
        }
      },
    );
    flutterBlue.stopScan();
    //   },
    // );
  }

  connectToDevice(device) async {
    flutterBlue.stopScan();
    try {
      if(!await FlutterBluePlus.instance.isOn){
        FlutterBluePlus.instance.turnOn();
      }
      await BluetoothDevice.fromId((device as BluetoothDevice).id.id).disconnect();
      await BluetoothDevice.fromId((device).id.id).connect();
      bleController.isConnected.value = true;
      var bluetoothServices = await device.discoverServices();
      final _setBluetoothServices = {bluetoothServices};
      debugPrint('_setBluetoothServices ${_setBluetoothServices}');

      bluetoothServices.toSet().toList();
      for (var element in bluetoothServices) {
        if (element.uuid.toString() == '6e400021-b5a3-f393-e0a9-e50e24dcca9e') {
          bleController.bluetoothServices = (element);
        }
      }
      getReadAndWriteServices();
    } catch (e) {
      debugPrint('======== Error is ========== $e');
      CommonWidgets().errorSnackbar(
        title: 'error',
        message: e.toString(),
      );
      if (e == 'already_connected') {
        CommonWidgets().errorSnackbar(
          title: 'error',
          message: 'already connected',
        );
      }
    } finally {}
    bleController.connectedDevice = device;
  }

  // differentiate services
  getReadAndWriteServices() async {
    for (var char in bleController.bluetoothServices!.characteristics) {
      debugPrint('char are $char');
      if (char.uuid.toString() == '6e400022-b5a3-f393-e0a9-e50e24dcca9e') {
        bleController.writeCharacteristics = char;
      } else if (char.uuid.toString() ==
          '6e400023-b5a3-f393-e0a9-e50e24dcca9e') {
        bleController.notifyCharacteristics = char;
      }
    }

    // notifying data
    try {
      bleController.notifyCharacteristics!.value.listen((event) {
        if (event.contains(127)) {
          debugPrint('notifyCharacteristics packet is ${event.toString()}');
          var hexData = [];
          for (var ele in event) {
            hexData.add(
              ele.toRadixString(16),
            );
          }
          if (deviceDetailsController.advancedSearchPage.value) {
            if (event.contains(243)) {
              debugPrint('in if');
              CommonWidgets()
                  .errorSnackbar(title: '', message: "Partial Packet Error");
            }
          }
          debugPrint('response packet is ${hexData.toString()}');
          var i = 0;
          String printstring = '';
          for (i = 0; i < event.length; i++) {
            printstring = '$printstring ${event[i].toRadixString(2)}';
          }
          debugPrint('printstring>>>>>>>  ${printstring.toString()}}');

          if (event.length > 8) {
            var dataLength = (event[6] << 8) + event[7];
            var dataIndex = 10;
            var value = '';
            var name = '';
            for (var i = 0; i < dataLength; i++) {
              var val = (event[dataIndex] << 8) + event[dataIndex + 1];
              var reg = (event[dataIndex - 2] << 8) + event[dataIndex - 1];
              debugPrint(' reg no: $reg  data in reg  is: $val');

              value += val.toString();
              name += reg.toString();
              DeviceDetailsService().checkingPresentPage(reg, val, event);
              dataIndex = dataIndex + 4;
            }
          } else {
            CommonWidgets().errorSnackbar(
                title: "", message: "error occured in respose packet");
          }
        }
        event = [];
      });
    } catch (e) {
      debugPrint('eroor while notifying is $e');
      CommonWidgets().errorSnackbar(
        title: '',
        message: e.toString(),
      );
    }

    if (!bleController.notifyCharacteristics!.isNotifying) {
      await bleController.notifyCharacteristics!.setNotifyValue(true);
      // packet sent for getting firm ware version
      await bleController.writeCharacteristics?.write([
        0x7e, //sof
        0x00, //len
        0x06, //len
        0x01, //deviceid
        0x10, //data len
        0x00, // data
        0x56, //crc
        0x8d, //crc
        0x7f //eof
      ]).whenComplete(() async {
        debugPrint('packet is sent');
      });
    }
  }

  stopScan() {
    flutterBlue.stopScan();
  }

  String decode(String value) {
    // Split the given value on spaces, parse each base-2 representation string to
    // an integer and return a new string from the corresponding code units
    return String.fromCharCodes(
        value.split(" ").map((v) => int.parse(v, radix: 2)));
  }

  sendPackets(time, registers) async {
    Future.delayed(Duration(milliseconds: time), () async {
      try {
        await PacketFrameService()
            .createPacket(registers, packetFrameController.subopcodeRead);
      } catch (e) {
        CommonWidgets().errorSnackbar(
          title: '',
          message: e.toString(),
        );
      }
    });
  }

  disconnectToDevice(device) async {
    try {
      await device.disconnect();
      debugPrint('disconnected');
      bleController.isConnected.value = false;
      bleController.isConnectionCancled.value = false;
      bleController.connectedDevice = null;
      bleController.selectedDevice = null;
      deviceDetailsController.sysOpsDataLoading.value = true;
      deviceDetailsController.model.value = '';
      deviceDetailsController.serial.value = '';
      deviceDetailsController.oduVersion.value = '';
      deviceDetailsController.iduVersion.value = '';
    } catch (e) {
      debugPrint(e.toString());
    }
  }

/*
  Future<bool> getLocationPermission() async {
    Location location = locator.Location() as Location;
    bool locationEnabled;
    PermissionStatus locationPermissionGranted;
    locationEnabled = await location.serviceEnabled();
    if (!locationEnabled) {
      locationEnabled = await location.requestService();
      if (!locationEnabled) {
        return false;
      }
    }
    locationPermissionGranted = await location.hasPermission();
    if (locationPermissionGranted == PermissionStatus.denied) {
      locationPermissionGranted = await location.requestPermission();
      if (locationPermissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
*/

  Future<bool> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return true;
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) async {
      debugPrint('_currentPosition ${position.toString()}');
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      bleController.currentAddress.value =
          "Street ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}.";
      debugPrint('placemarks ${placemarks.toString()}');
    }).catchError((e) {
      print(e);
    });
  }
}
