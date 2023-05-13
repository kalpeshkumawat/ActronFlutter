import 'dart:async';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/models/constants.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:airlink/views/devices_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import '../controllers/ble_controller.dart';
import 'device_details_service.dart';

class BleService {
  static final BleService _bleService = BleService._internal();

  factory BleService() {
    return _bleService;
  }

  BleService._internal();

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final bleController = Get.find<BleController>(tag: 'bleController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  Location location = Location();
  late StreamSubscription notifyListener;

  scanDevice() async {
    bleController.scanComplete.value = false;
    await flutterBlue
        .startScan(
      timeout: const Duration(seconds: 4),
    )
        .whenComplete(
      () async {
        // bleController.scanComplete.value = true;
        bleController.isRescan.value = false;
        flutterBlue.scanResults.listen(
          (List<ScanResult> devices) {
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
      },
    );
  }

  connectToDevice(BluetoothDevice device) async {
    flutterBlue.stopScan();
    // try {
    await device
        .connect(
      autoConnect: true,
      timeout: const Duration(
        seconds: 15,
      ),
    )
        .whenComplete(() async {
      print('device connection state ${await device.state.first}');
      if (await device.state.first == BluetoothDeviceState.connected) {
        bleController.isConnected.value = true;
        var bluetoothServices = await device.discoverServices();
        for (var element in bluetoothServices) {
          if (element.uuid.toString() == Constants.bluetoothService) {
            bleController.bluetoothServices = (element);
          }
        }
        getReadAndWriteServices();
        bleController.connectedDevice = device;
      }
    }).onError((error, stackTrace) {
      Get.to(
        () => const DevicesFound(),
      );
      CommonWidgets().errorSnackbar(
          title: '', message: 'Could\'nt connect to device, please try again');
    });
  }

  // differentiate services
  getReadAndWriteServices() async {
    for (var char in bleController.bluetoothServices!.characteristics) {
      if (char.uuid.toString() == Constants.writeCharecteristic) {
        bleController.writeCharacteristics = char;
      } else if (char.uuid.toString() == Constants.notifyCharecteristic) {
        bleController.notifyCharacteristics = char;
      }
    }

    try {
      notifyListener.cancel();
    } catch (e) {
      print(e);
    }
    // notifying data
    try {
      notifyListener =
          bleController.notifyCharacteristics!.value.listen((event) {
        debugPrint(event.toString());
        if (event.contains(127)) {
          var hexData = [];
          for (var ele in event) {
            hexData.add(
              ele.toRadixString(16),
            );
          }

          debugPrint('response packet is ${hexData.toString()}');
          var i = 0;
          String printstring = '';
          for (i = 0; i < event.length; i++) {
            printstring = '$printstring ${event[i].toRadixString(16)}';
          }
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
            DeviceDetailsService().formGraphData();
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
      debugPrint('setting notify');
    }
  }

  stopScan() {
    flutterBlue.stopScan();
  }

  sendPackets(time, registers) async {
    Future.delayed(Duration(milliseconds: time), () async {
      try {
        await PacketFrameService()
            .createPacket(registers, packetFrameController.subopcodeRead);
      } catch (e) {
        debugPrint('error while sending packets is ${e.toString()}');
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

  getLanLon() async {
    bool locationEnabled;
    PermissionStatus locationPermissionGranted;
    LocationData locationData;

    locationEnabled = await location.serviceEnabled();
    if (!locationEnabled) {
      locationEnabled = await location.requestService();
      if (!locationEnabled) {
        return;
      }
    }

    locationPermissionGranted = await location.hasPermission();
    if (locationPermissionGranted == PermissionStatus.denied) {
      locationPermissionGranted = await location.requestPermission();
      if (locationPermissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    bleController.lon = locationData.longitude!;
    bleController.lan = locationData.latitude!;
  }
}
