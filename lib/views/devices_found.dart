import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/views/connecting_to_device.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/packet_frame_controller.dart';

class DevicesFound extends StatefulWidget {
  const DevicesFound({Key? key}) : super(key: key);

  @override
  State<DevicesFound> createState() => _DevicesFoundState();
}

class _DevicesFoundState extends State<DevicesFound> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final packetFrameController =
  Get.find<PacketFrameController>(tag: 'packetFrameController');

  int selectedValue = -1;
  late String deviceId;

  String? get address => null;

  @override
  void initState() {
    BleService().stopScan();
    disconnectDevice();
    super.initState();

  }

  disconnectDevice() async {
    if (bleController.isConnected.value) {
      await BleService().disconnectToDevice(bleController.connectedDevice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              'Discovered Devices',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: [
              bleController.devicesFound.isEmpty
                  ? IconButton(
                      onPressed: () {
                        bleController.devicesFound.clear();
                        bleController.isRescan.value = true;
                        BleService().scanDevice();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
            ]),
        body: Obx(() {
          return !bleController.isConnectionCancled.value
              ? Stack(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CommonWidgets().text(
                          bleController.devicesFound.isEmpty
                              ? 'No Devices Found'
                              : '${bleController.devicesFound.length} Devices${bleController.devicesFound.length > 1 ? "s" : ""} Found',
                          24.0,
                          FontWeight.bold,
                          TextAlign.center,
                          Colors.black,
                          'Inter'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: CommonWidgets().text(
                            '	Please refer to the serial number on the base of the Actron Link hardware, select from the list below and touch Pair to connect.',
                            16.0,
                            FontWeight.normal,
                            TextAlign.center,
                            Colors.grey,
                            'karbon'),
                      ),
                      Container(
                        margin: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        child: Obx(
                          () => bleController.devicesFound.isEmpty
                              ? Center(
                                  child: CommonWidgets().text(
                                      'No Devices Found',
                                      14.0,
                                      FontWeight.w400,
                                      TextAlign.start,
                                      Colors.black,
                                      'Karbon'),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(10.0),
                                  itemCount: bleController.devicesFound.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      decoration:
                                          const BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(88, 89, 91, .3),
                                            blurRadius: 7.0)
                                      ]),
                                      child: Card(
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 15),
                                          title: Row(
                                            children: [
                                              CommonWidgets().text(
                                                  bleController
                                                      .devicesFound[i].name,
                                                  17.0,
                                                  FontWeight.w600,
                                                  TextAlign.start,
                                                  const Color(0xff4da6de),
                                                  'Karbon')
                                            ],
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .48,
                                                  child: CommonWidgets().text(
                                                      bleController
                                                          .devicesFound[i].id
                                                          .toString(),
                                                      16.0,
                                                      FontWeight.w600,
                                                      TextAlign.start,
                                                      Colors.black,
                                                      'Karbon'),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Checkbox(
                                              shape: const CircleBorder(),
                                              value: selectedValue == i,
                                              onChanged: (_) {
                                                selectedValue = i;
                                                setState(() {});
                                                bleController.selectedDevice =
                                                    bleController
                                                        .devicesFound[i];
                                              }),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: selectedValue != -1
                            ? () => {
                                  debugPrint(
                                      'selected device is ${bleController.selectedDevice}'),
                                  BleService().stopScan(),
                                  Get.to(
                                    () => const ConnectingToDevice(),
                                  ),
                                }
                            : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 6.0,
                          primary: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 14.0),
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                          ),
                          minimumSize: const Size(200.0, 48.0),
                        ),
                        child: const Text('Pair'),
                      )
                    ],
                  ),
                  if (bleController.isRescan.value)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ])
              : const Center(
                  child: CircularProgressIndicator(),
                );
        }),
      ),
    );
  }
}
