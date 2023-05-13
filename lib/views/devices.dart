import 'dart:convert';
import 'dart:io';

import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/services/db_service.dart';
import 'package:airlink/services/import_export_service.dart';
import 'package:airlink/views/deviceScreen/device_details.dart';
import 'package:airlink/views/pairing_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../services/ble_service.dart';
import 'infoScreen/information_page.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final packetFrameController =
      Get.put(PacketFrameController(), tag: 'packetFrameController');

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List deviceDetials = [];

  late bool permissionGranted;

  @override
  void initState() {
    getDevices();
    super.initState();
  }

  getDevices() async {
    await DbService().getSavedDevices(deviceDetials);
    await BleService().getLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(
                'Devices',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0),
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () => {Get.to(() => const Information())},
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    dialog(context);
                  },
                  child: Image.asset(
                    'assets/network.png',
                    height: 15,
                    width: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 23.0,
              ),
              Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * .75,
                  child: bleController.savedDevices.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemCount: bleController.savedDevices.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onLongPress: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CommonWidgets().deleteDeviceDialog(
                                          context: context,
                                          i: i,
                                          deviceDetials: deviceDetials),
                                );

                                setState(() {});
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 10.0, right: 20.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonWidgets().text(
                                              bleController.savedDevices[i]
                                                  ['name'],
                                              24.0,
                                              FontWeight.w600,
                                              TextAlign.left,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              'karbon'),
                                          CommonWidgets().button(
                                              name: 'Details',
                                              function: () async {
                                                for (var element in bleController
                                                    .localBluetoothDevices) {
                                                  if (bleController
                                                              .savedDevices[i]
                                                          ['id'] ==
                                                      element.id.toString()) {
                                                    bleController.selectedId =
                                                        element.id.toString();
                                                    bleController
                                                            .selectedDevice =
                                                        element;
                                                    BleService().connectToDevice(bleController.selectedDevice);
                                                  }
                                                }
                                                Get.to(() =>
                                                    const DeviceDeatails());
                                              },
                                              buttonColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 170.0,
                                              height: 52.0),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          children: [
                                            CommonWidgets().text(
                                                bleController.savedDevices[i]
                                                    ['id'],
                                                14.0,
                                                FontWeight.w500,
                                                TextAlign.left,
                                                const Color.fromRGBO(
                                                    121, 121, 121, 1),
                                                'karbon'),
                                            const Spacer(),
                                            CommonWidgets().text(
                                                bleController.savedDevices[i]
                                                        ['date']
                                                    .toString()
                                                    .substring(0, 16),
                                                14.0,
                                                FontWeight.w500,
                                                TextAlign.center,
                                                const Color.fromRGBO(
                                                    121, 121, 121, 1),
                                                'karbon'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Text(
                          'No saved devices',
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      goToPairingPage();
                    },
                    label: const Icon(
                      Icons.bluetooth,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: CommonWidgets().text('Add', 20.0, FontWeight.w600,
                          TextAlign.left, Colors.white, 'karbon'),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minimumSize: const Size(100.0, 48.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CommonWidgets().importExportDialog(
          context: context,
          importFunction: () {
            importData(context);
          },
          exportFunction: () {
            exportData(context);
          }),
    );
  }

  importData(context) {
    openFile(context);
  }

  openFile(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(
        result.files.single.path.toString(),
      );
      debugPrint('file path is $file');
      var data = await ImportExportService().importDataFromFile(file);
      debugPrint(data);
      debugPrint(
          'type of data is ${(jsonEncode(data))}, ${jsonEncode(data).runtimeType}');
      await DbService().saveDevice(data, true);
      await DbService().readStringList('devices');
    } else {
      CommonWidgets().errorSnackbar(title: '', message: 'No file selected');
    }
    Navigator.pop(context);
  }

  exportData(context) async {
    if (bleController.savedDevices.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CommonWidgets()
            .selectDeviceDialog(context, bleController.savedDevices),
      );
      Navigator.pop(context);
    } else {
      CommonWidgets().errorSnackbar(
          title: "", message: 'Please save device to export data');
    }
    // Navigator.pop(context);
  }

  goToPairingPage() async {
    if (await flutterBlue.isOn == false) {
      try {
        await flutterBlue.turnOn();
        Get.to(
          () => const PairingScreen(),
        );
      } catch (e) {
        debugPrint('error is ${e.toString()}');
        Get.to(
          () => const PairingScreen(),
        );
      }
    }
    if (await flutterBlue.isOn == true) {
      Get.to(
        () => const PairingScreen(),
      );
    }
  }
}
