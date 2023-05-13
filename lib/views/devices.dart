import 'dart:convert';
import 'dart:io';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/services/device_db_service.dart';
import 'package:airlink/services/import_export_service.dart';
import 'package:airlink/views/deviceScreen/device_details.dart';
import 'package:airlink/views/pairing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../services/ble_service.dart';
import 'infoScreen/information_page.dart';
import 'package:file_picker/file_picker.dart';

class Devices extends StatefulWidget {
  const Devices({Key? key}) : super(key: key);

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final packetFrameController =
      Get.put(PacketFrameController(), tag: 'packetFrameController');
  final homeController = Get.find<HomeController>(tag: 'homeController');
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List deviceDetials = [];

  @override
  void initState() {
    DeviceDbService().queryDeviceDetails();
    getAddressFromLatLng();
    super.initState();
  }

  getAddressFromLatLng() async {
    await BleService().getLanLon();
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(bleController.lan, bleController.lon);
      Placemark place = placemarks[0];

      bleController.currentAddress.value =
          "Street ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}.";
      debugPrint(bleController.currentAddress.value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                child: homeController.savedDevices.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: homeController.savedDevices.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onLongPress: () async {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CommonWidgets().deleteDeviceDialog(
                                        context: context,
                                        id: homeController.savedDevices[i].id,
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
                                          text: homeController
                                              .savedDevices[i].name,
                                          size: 24.0,
                                          fontWeight: FontWeight.w600,
                                          textColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontFamily: 'karbon',
                                        ),
                                        CommonWidgets().button(
                                            name: 'Details',
                                            function: () {
                                              for (var element in bleController
                                                  .localBluetoothDevices) {
                                                if (homeController
                                                        .savedDevices[i].id ==
                                                    element.id.toString()) {
                                                  bleController.selectedId =
                                                      element.id.toString();
                                                  bleController.selectedDevice =
                                                      element;
                                                }
                                              }
                                              Get.to(
                                                  () => const DeviceDeatails());
                                            },
                                            buttonColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 80.0,
                                            height: 32.0),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonWidgets().text(
                                          text:
                                              homeController.savedDevices[i].id,
                                          size: 14.0,
                                          fontWeight: FontWeight.w500,
                                          textColor: const Color.fromRGBO(
                                              121, 121, 121, 1),
                                          fontFamily: 'karbon',
                                        ),
                                        CommonWidgets().text(
                                          text: homeController
                                              .savedDevices[i].lastUpdatedDate
                                              .toString(),
                                          size: 14.0,
                                          fontWeight: FontWeight.w500,
                                          textColor: const Color.fromRGBO(
                                              121, 121, 121, 1),
                                          fontFamily: 'karbon',
                                        ),
                                      ],
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
                    child: CommonWidgets().text(
                        text: 'Add',
                        size: 20.0,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                        fontFamily: 'karbon'),
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
    } else {
      CommonWidgets().errorSnackbar(title: '', message: 'No file selected');
    }
    Navigator.pop(context);
  }

  exportData(context) async {
    if (homeController.savedDevices.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CommonWidgets().selectDeviceDialog(
          context: context,
          listOfDevices: homeController.savedDevices,
        ),
      );
      Navigator.pop(context);
    } else {
      CommonWidgets().errorSnackbar(
          title: "", message: 'Please save device to export data');
    }
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
