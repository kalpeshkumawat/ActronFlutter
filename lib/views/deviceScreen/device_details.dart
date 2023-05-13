import 'dart:async';

import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/controllers/system_configuration_controller.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/views/deviceScreen/error_history.dart';
import 'package:airlink/views/deviceScreen/graph.dart';
import 'package:airlink/views/deviceScreen/sysOpsScreen/system_operations.dart';
import 'package:airlink/views/deviceScreen/system_configuration.dart';
import 'package:airlink/views/devices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/db_service.dart';

class DeviceDeatails extends StatefulWidget {
  const DeviceDeatails({Key? key}) : super(key: key);

  @override
  State<DeviceDeatails> createState() => _DeviceDeatailsState();
}

class _DeviceDeatailsState extends State<DeviceDeatails> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');
  final deviceName = TextEditingController();
  final httpsUri = Uri.parse('https://webstore.actronair.com.au/');
  bool showLocationIcon = false;
  bool isBluetoothOn = false;

  @override
  void initState() {
    bleController.selectedDevice;
    if (deviceDetailsController.model.value == '') {
      deviceDetailsController.deviceDetailsPage.value = true;
      deviceDetailsController.operationsTillHpPressure.value = false;
      deviceDetailsController.operationsTillVsdMotor.value = false;
      deviceDetailsController.errorsCodesRegistry.value = false;
      deviceDetailsController.errorsDatesRegistry.value = false;
      deviceDetailsController.errorsTimesRegistry.value = false;
      deviceDetailsController.economiserSettingPage.value = false;
      deviceDetailsController.graphPage.value = false;
      deviceDetailsController.advancedSearchPage.value = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        deviceDetailsController.model.value = '';
        deviceDetailsController.serial.value = '';
        deviceDetailsController.oduVersion.value = '';
        deviceDetailsController.iduVersion.value = '';
      });
      if (bleController.connectedDevice != null) {
        if (deviceDetailsController.model.value.isEmpty) {
          BleService()
              .sendPackets(50, packetFrameController.deviceDetailsRegisters);
        }
        deviceDetailsController.activeErrorsRegistry.value = true;
        BleService().sendPackets(250, packetFrameController.activeError);
      } else {
        getDeviceDetailsFromLocalStorage();
      }
    }
    initLocation();
    super.initState();
  }

  @override
  void dispose() {
    deviceDetailsController.deviceDetailsPage.value = false;
    super.dispose();
  }

  initLocation() async {
    BleService().getCurrentLocation();
    if (await BleService().isLocationServiceEnabled()) {
      setState(() {
        showLocationIcon = true;
      });
    }

    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      setState(
        () {
          showLocationIcon = status == ServiceStatus.enabled ? true : false;
          debugPrint('showLocationIcon $showLocationIcon');
        },
      );
    });
  }

  getDeviceDetailsFromLocalStorage() async {
    for (var element in bleController.savedDevices) {
      if (element['id'] == bleController.selectedId) {
        deviceDetailsController.model.value = await element['model'];
        deviceDetailsController.serial.value = await element['serial'];
        deviceDetailsController.iduVersion.value = await element['iduVersion'];
        deviceDetailsController.oduVersion.value = await element['oduVersion'];
        deviceDetailsController.commissionedDate = await element['date'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  // ignore: unnecessary_const
                  child: Text(
                    'Device Details',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // SQFLITE FUNCTIONALITY
                    // await SqlDbService().addDeviceToDB();
                    // await SqlDbService().queryDetails();
                    deviceDetailsController.commissionedDate =
                        deviceDetailsController.date;
                    DbService()
                        .saveDevice(bleController.selectedDevice!, false);
                  },
                  icon: const Icon(Icons.save),
                  color: Colors.white,
                  iconSize: 20.0,
                )
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                await showDeviceSavingDialogBeforeLeaving();
              },
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Column(
                      children: [
                        // firstrow
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(88, 89, 91, .3),
                                  blurRadius: 7.0)
                            ],
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      _inputDialog(context));
                                            },
                                            child: CommonWidgets().text(
                                                bleController.selectedDevice !=
                                                        null
                                                    ? bleController
                                                        .selectedDevice!.name
                                                    : '',
                                                24,
                                                FontWeight.w600,
                                                TextAlign.start,
                                                const Color.fromRGBO(
                                                    65, 64, 66, 1),
                                                'karbon'),
                                          ),
                                          CommonWidgets().text(
                                              bleController.connectedDevice !=
                                                      null
                                                  ? 'Last Updated ${deviceDetailsController.date.toString()}'
                                                  : deviceDetailsController
                                                      .commissionedDate,
                                              14,
                                              FontWeight.w600,
                                              TextAlign.start,
                                              Colors.grey,
                                              'karbon'),
                                        ],
                                      ),
                                      if (bleController.selectedDevice != null)
                                        StreamBuilder(
                                          stream:FlutterBluePlus.instance.state,
                                          initialData:
                                          BluetoothState.off,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            return snapshot.data ==
                                                BluetoothState.on
                                                ? Icon(
                                                    Icons.bluetooth,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 20,
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CommonWidgets()
                                                                .connectConfirmDialog(
                                                                    context),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.bluetooth_disabled,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 20,
                                                    ),
                                                  );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                                // second row
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                  'Model: ${deviceDetailsController.model.value != '' ? deviceDetailsController.model.value : '--'}',
                                                  14,
                                                  FontWeight.w600,
                                                  TextAlign.start,
                                                  const Color.fromRGBO(
                                                      65, 64, 66, 1),
                                                  'karbon'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                  'Serial: ${deviceDetailsController.serial.isNotEmpty ? deviceDetailsController.serial.value : '--'}',
                                                  14,
                                                  FontWeight.w600,
                                                  TextAlign.start,
                                                  const Color.fromRGBO(
                                                      65, 64, 66, 1),
                                                  'karbon'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: CommonWidgets().text(
                                                'Commissioned: ${bleController.connectedDevice != null ? deviceDetailsController.commissionedDate.toString() : bleController.commissionedDate}',
                                                14,
                                                FontWeight.w600,
                                                TextAlign.start,
                                                const Color.fromRGBO(
                                                    65, 64, 66, 1),
                                                'karbon'),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                  'ODU Version: ${deviceDetailsController.oduVersion.value != '' ? deviceDetailsController.oduVersion.value : '--'}',
                                                  14,
                                                  FontWeight.w600,
                                                  TextAlign.start,
                                                  const Color.fromRGBO(
                                                      65, 64, 66, 1),
                                                  'karbon'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                  'IDU Version: ${deviceDetailsController.iduVersion.value != '' ? deviceDetailsController.iduVersion.value : '--'}',
                                                  14,
                                                  FontWeight.w600,
                                                  TextAlign.start,
                                                  const Color.fromRGBO(
                                                      65, 64, 66, 1),
                                                  'karbon'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                  'Active Error: ${deviceDetailsController.activeError.value != '' ? deviceDetailsController.activeError.value : '--'}',
                                                  14,
                                                  FontWeight.w600,
                                                  TextAlign.start,
                                                  const Color.fromRGBO(
                                                      65, 64, 66, 1),
                                                  'karbon'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Obx(() => bleController.currentAddress
                                                      .value.isNotEmpty &&
                                                  showLocationIcon
                                              ? const Icon(
                                                  Icons.location_on,
                                                  color: Colors.black,
                                                  size: 20.0,
                                                )
                                              : const Icon(
                                                  Icons.location_off,
                                                  color: Colors.black,
                                                  size: 20.0,
                                                )),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Obx(() => CommonWidgets()
                                                .text(
                                                    bleController
                                                                .currentAddress
                                                                .value
                                                                .isNotEmpty &&
                                                            showLocationIcon
                                                        ? bleController
                                                            .currentAddress
                                                            .value
                                                            .toString()
                                                        : '',
                                                    16.0,
                                                    FontWeight.w600,
                                                    TextAlign.end,
                                                    Colors.black,
                                                    'karbon')),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        // buttons Column
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonWidgets().button(
                                    name: 'Operate',
                                    function: () {
                                      Get.to(
                                        () => const SystemOperations(),
                                      );
                                    },
                                    buttonColor:
                                        Theme.of(context).colorScheme.primary,
                                    width: 170.0,
                                    height: 52.0),
                                CommonWidgets().button(
                                    name: 'Configure',
                                    function: () async {
                                      Get.to(
                                        () => const SystemConfiguration(),
                                      );
                                    },
                                    buttonColor:
                                        Theme.of(context).colorScheme.primary,
                                    width: 170.0,
                                    height: 52.0),
                                CommonWidgets().button(
                                    name: 'Monitor',
                                    function: () => {
                                          Get.to(
                                            () => const Graph(),
                                          ),
                                        },
                                    buttonColor:
                                        Theme.of(context).colorScheme.primary,
                                    width: 170.0,
                                    height: 52.0),
                                CommonWidgets().button(
                                    name: 'Error History',
                                    function: () =>
                                        {Get.to(() => const ErrorHistory())},
                                    buttonColor:
                                        Theme.of(context).colorScheme.primary,
                                    width: 170.0,
                                    height: 52.0),
                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 28.0,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          'Webstore',
                                          style: TextStyle(
                                              shadows: [
                                                Shadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    offset: const Offset(0, -3))
                                              ],
                                              color: Colors.transparent,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 2,
                                              decorationColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () => {
                                    launchUrl(httpsUri),
                                  },
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputDialog(BuildContext context) {
    deviceName.clear();
    return Dialog(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .24,
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.5),
              child: TextField(
                autofocus: true,
                controller: deviceName,
                decoration: const InputDecoration(
                    labelText: 'Enter Device Name',
                    border: OutlineInputBorder(),
                    hintText: "Device Name",
                    contentPadding: EdgeInsets.only(bottom: 7.0, left: 5.0)),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonWidgets().button(
                    name: "Submit",
                    function: () {
                      if (deviceName.text == '') {
                        Fluttertoast.showToast(msg: "name can't be empty");
                      } else {
                        bleController.newDeviceName = deviceName.text;
                        Navigator.of(context).pop();
                      }
                    },
                    buttonColor: Theme.of(context).colorScheme.primary,
                    width: 100.0,
                    height: 42.0),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showDeviceSavingDialogBeforeLeaving() {
    return Get.defaultDialog(
      title: "Do you want to save the device?",
      middleText: '',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonWidgets().richText(
              name: 'Cancel',
              color: Colors.red,
              size: 16.0,
              function: () async {
                BleService().disconnectToDevice(bleController.selectedDevice!);
                Get.to(
                  () => const Devices(),
                );
              },
            ),
            const SizedBox(
              width: 40.0,
            ),
            CommonWidgets().richText(
              name: 'Ok',
              color: Theme.of(context).colorScheme.primary,
              size: 16.0,
              function: () async {
                await DbService().saveDevice(
                  bleController.selectedDevice!,
                  false,
                );
                Get.to(
                  () => const Devices(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
