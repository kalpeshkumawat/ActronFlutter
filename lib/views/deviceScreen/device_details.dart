import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/controllers/system_configuration_controller.dart';
import 'package:airlink/models/device_details_model.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/services/device_db_service.dart';
import 'package:airlink/services/device_details_service.dart';
import 'package:airlink/views/deviceScreen/sysOpsScreen/system_operations.dart';
import 'package:airlink/views/devices.dart';
import 'package:airlink/views/deviceScreen/error_history.dart';
import 'package:airlink/views/deviceScreen/graph.dart';
import 'package:airlink/views/deviceScreen/system_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

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
  final homeController = Get.find<HomeController>(tag: 'homeController');
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');
  final deviceName = TextEditingController();
  final httpsUri = Uri.parse('https://webstore.actronair.com.au/');
  Position? currentPosition;
  var date;

  @override
  void initState() {
    date = DateFormat.yMMMMd('en_US').format(DateTime.now());
    var isDevicePresent = homeController.savedDevices
        .where((element) => element.id == bleController.selectedId)
        .isEmpty;
    if (!isDevicePresent) {
      deviceDetailsController.lastUpdatedDate.value = date;
      deviceDetailsController.lastUpdatedDate.value = date;
    }
    deviceDetailsController.deviceName.value.text =
        bleController.selectedDevice!.name;
    DeviceDetailsService().managingPages(pageNumber: 1);
    if (bleController.connectedDevice != null) {
      BleService()
          .sendPackets(50, packetFrameController.deviceDetailsRegisters);
      deviceDetailsController.activeErrorsRegistry.value = true;
      BleService().sendPackets(250, packetFrameController.activeError);
    } else {
      getDeviceDetailsFromLocalStorage();
    }
    super.initState();
  }

  @override
  void dispose() {
    deviceDetailsController.deviceDetailsPage.value = false;
    super.dispose();
  }

  getDeviceDetailsFromLocalStorage() async {
    for (DeviceDetailsModel element in homeController.savedDevices) {
      if (element.id == bleController.selectedId) {
        deviceDetailsController.model.value = element.model;
        deviceDetailsController.serial.value = element.serial;
        deviceDetailsController.iduVersion.value = element.iduVersion;
        deviceDetailsController.oduVersion.value = element.oduVersion;
        deviceDetailsController.commissionedDate.value =
            element.comissionedDate;
        deviceDetailsController.lastUpdatedDate.value = element.lastUpdatedDate;
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
                  child: Text(
                    'Device Details',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0),
                  ),
                ),
                StreamBuilder(
                  stream: bleController.selectedDevice!.state,
                  initialData: BluetoothDeviceState.disconnected,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.data == BluetoothDeviceState.connected
                        ? IconButton(
                            onPressed: () async {
                              await DeviceDbService().addDeviceToDB();
                              await DeviceDbService().queryDeviceDetails();
                            },
                            icon: const Icon(Icons.save),
                            color: Colors.white,
                            iconSize: 20.0,
                          )
                        : const SizedBox();
                  },
                ),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: CommonWidgets().text(
                    text:
                        'Do you want to save the device ${deviceDetailsController.deviceName.value.text} ?',
                    size: 16.0,
                    fontFamily: 'karbon',
                    fontWeight: FontWeight.w600,
                    textColor: Colors.black,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {
                        BleService()
                            .disconnectToDevice(bleController.selectedDevice!),
                        Get.to(
                          () => const Devices(),
                        )
                      },
                      child: CommonWidgets().text(
                        text: 'Cancel',
                        size: 14.0,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.red,
                        fontFamily: 'Karbon',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await DeviceDbService().addDeviceToDB();
                        Get.to(
                          () => const Devices(),
                        );
                      },
                      child: CommonWidgets().text(
                        text: 'Ok',
                        size: 14.0,
                        fontWeight: FontWeight.w600,
                        textColor: Theme.of(context).colorScheme.primary,
                        fontFamily: 'Karbon',
                      ),
                    ),
                  ],
                ),
              ),
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
                                                builder:
                                                    (BuildContext context) =>
                                                        changeDeviceNameDialog(
                                                  context,
                                                ),
                                              );
                                            },
                                            child: CommonWidgets().text(
                                              text: deviceDetailsController
                                                  .deviceName.value.text,
                                              size: 24.0,
                                              fontWeight: FontWeight.w600,
                                              textColor: const Color.fromRGBO(
                                                  65, 64, 66, 1),
                                              fontFamily: 'karbon',
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              return CommonWidgets().text(
                                                text:
                                                    'Last Updated ${deviceDetailsController.lastUpdatedDate.value}',
                                                size: 14.0,
                                                fontWeight: FontWeight.w600,
                                                textColor: Colors.grey,
                                                fontFamily: 'karbon',
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      if (bleController.selectedDevice != null)
                                        StreamBuilder(
                                          stream: bleController
                                              .selectedDevice!.state,
                                          initialData:
                                              BluetoothDeviceState.disconnected,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            return snapshot.data ==
                                                    BluetoothDeviceState
                                                        .connected
                                                ? Icon(
                                                    Icons.bluetooth,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 20.0,
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CommonWidgets()
                                                                .connectConfirmDialog(
                                                                    context:
                                                                        context),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.bluetooth_disabled,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 20.0,
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
                                                text:
                                                    'Model: ${deviceDetailsController.model.value != '' ? deviceDetailsController.model.value : '--'}',
                                                size: 14.0,
                                                fontWeight: FontWeight.w600,
                                                textColor: const Color.fromRGBO(
                                                    65, 64, 66, 1),
                                                fontFamily: 'karbon',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                text:
                                                    'Serial: ${deviceDetailsController.serial.value != '' ? deviceDetailsController.serial.value : '--'}',
                                                size: 14.0,
                                                fontWeight: FontWeight.w600,
                                                textColor: const Color.fromRGBO(
                                                    65, 64, 66, 1),
                                                fontFamily: 'karbon',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () {
                                                return CommonWidgets().text(
                                                  text:
                                                      'Commissioned: ${deviceDetailsController.commissionedDate}',
                                                  size: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  textColor:
                                                      const Color.fromRGBO(
                                                          65, 64, 66, 1),
                                                  fontFamily: 'karbon',
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                text:
                                                    'ODU Version: ${deviceDetailsController.oduVersion.value != '' ? deviceDetailsController.oduVersion.value : '--'}',
                                                size: 14.0,
                                                fontWeight: FontWeight.w600,
                                                textColor: const Color.fromRGBO(
                                                    65, 64, 66, 1),
                                                fontFamily: 'karbon',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.1,
                                            child: Obx(
                                              () => CommonWidgets().text(
                                                text:
                                                    'IDU Version: ${deviceDetailsController.iduVersion.value != '' ? deviceDetailsController.iduVersion.value : '--'}',
                                                size: 14.0,
                                                fontWeight: FontWeight.w600,
                                                textColor: const Color.fromRGBO(
                                                    65, 64, 66, 1),
                                                fontFamily: 'karbon',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                            size: 20.0,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: CommonWidgets().text(
                                              text: bleController
                                                  .currentAddress.value
                                                  .toString(),
                                              size: 16.0,
                                              fontWeight: FontWeight.w600,
                                              textColor: Colors.black,
                                              fontFamily: 'karbon',
                                            ),
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

  Widget changeDeviceNameDialog(BuildContext context) {
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
                controller: deviceDetailsController.deviceName.value,
                decoration: const InputDecoration(
                  labelText: 'Enter Device Name',
                  border: OutlineInputBorder(),
                  hintText: "Device Name",
                  contentPadding: EdgeInsets.only(bottom: 7.0, left: 5.0),
                ),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonWidgets().button(
                  name: "Submit",
                  function: () {
                    if (deviceDetailsController.deviceName.value.text == '') {
                      Fluttertoast.showToast(msg: "name can't be empty");
                    } else {
                      bleController.newDeviceName = deviceName.text;
                      Navigator.of(context).pop();
                    }
                  },
                  buttonColor: Theme.of(context).colorScheme.primary,
                  width: 100.0,
                  height: 42.0,
                ),
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
}
