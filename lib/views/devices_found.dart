import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/views/connecting_to_device.dart';
import 'package:airlink/views/devices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevicesFound extends StatefulWidget {
  const DevicesFound({Key? key}) : super(key: key);

  @override
  State<DevicesFound> createState() => _DevicesFoundState();
}

class _DevicesFoundState extends State<DevicesFound> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  int selectedValue = -1;
  late String deviceId;

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
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => const Devices());
        return false;
      },
      child: SafeArea(
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
          body: Obx(
            () {
              return !bleController.isConnectionCancled.value
                  ? Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CommonWidgets().text(
                              text:
                                  '${bleController.devicesFound.isEmpty ? 'No' : bleController.devicesFound.length} Device${bleController.devicesFound.length > 1 ? "s" : ""} Found',
                              size: 24.0,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.black,
                              fontFamily: 'Inter',
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: CommonWidgets().text(
                                text:
                                    'Please reference your serial number from the base of the ActronLink, llocate it in the list below and simply touch "Pair" to connect.',
                                size: 16.0,
                                fontWeight: FontWeight.normal,
                                textColor: Colors.grey,
                                fontFamily: 'karbon',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              child: Obx(
                                () => bleController.devicesFound.isEmpty
                                    ? Center(
                                        child: CommonWidgets().text(
                                          text: 'No Devices Found',
                                          size: 14.0,
                                          fontWeight: FontWeight.w400,
                                          textColor: Colors.black,
                                          fontFamily: 'Karbon',
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.all(10.0),
                                        itemCount:
                                            bleController.devicesFound.length,
                                        itemBuilder: (context, i) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color.fromRGBO(
                                                          88, 89, 91, .3),
                                                      blurRadius: 7.0)
                                                ]),
                                            child: Card(
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15),
                                                title: Row(
                                                  children: [
                                                    CommonWidgets().text(
                                                      text: bleController
                                                          .devicesFound[i].name,
                                                      size: 17.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      textColor: const Color(
                                                          0xff4da6de),
                                                      fontFamily: 'Karbon',
                                                    )
                                                  ],
                                                ),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .48,
                                                        child: CommonWidgets()
                                                            .text(
                                                          text: bleController
                                                              .devicesFound[i]
                                                              .id
                                                              .toString(),
                                                          size: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.black,
                                                          fontFamily: 'Karbon',
                                                        ),
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
                                                      bleController
                                                              .selectedDevice =
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
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ),
      ),
    );
  }
}
