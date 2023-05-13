import 'dart:async';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/models/system_operations_model.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/services/device_details_service.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/packet_frame_controller.dart';
import 'advanced_search.dart';

class SystemOperations extends StatefulWidget {
  const SystemOperations({Key? key}) : super(key: key);

  @override
  State<SystemOperations> createState() => _SystemOperationsState();
}

class _SystemOperationsState extends State<SystemOperations> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final homeController = Get.find<HomeController>(tag: 'homeController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  final ScrollController scrollControllerOne = ScrollController();
  final ScrollController scrollControllerTwo = ScrollController();
  TextEditingController data = TextEditingController();
  var timer;
  var operationModes = ['', 'OFF', 'Cool', 'Heat', 'Fan', 'Auto'];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {});
    DeviceDetailsService().managingPages(pageNumber: 2);
    if (bleController.connectedDevice != null) {
      bleController.connectedDevice!.requestMtu(128).whenComplete(() async {});
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (timer) async {
          BleService().sendPackets(100, packetFrameController.sysOps);
        },
      );
    } else {
      getSystemOperationsData();
    }
    super.initState();
  }

  @override
  void dispose() {
    deviceDetailsController.systemOperationsPage.value = false;
    bleController.connectedDevice != null ? timer.cancel() : null;
    operationModes.clear();
    super.dispose();
  }

  getSystemOperationsData() async {
    deviceDetailsController.sysOpsDataLoading.value = false;
    for (SystemOperationsModel element
        in homeController.deviceSystemOperationsData) {
      print('sys ops data form db is ${element.toJson()}');
      deviceDetailsController.updateSystemOpsData(element);
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
              'System Operations',
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              bleController.connectedDevice != null
                  ? await timer.cancel()
                  : null;
              Get.back();
            },
          ),
        ),
        body: Obx(
          () => Stack(
            children: [
              ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            // firstrow
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: CommonWidgets().text(
                                        text: bleController.selectedDevice !=
                                                null
                                            ? bleController.selectedDevice!.name
                                            : '',
                                        size: 24.0,
                                        fontWeight: FontWeight.bold,
                                        textColor:
                                            const Color.fromRGBO(65, 64, 66, 1),
                                        fontFamily: 'karbon',
                                      ),
                                    ),
                                    CommonWidgets().text(
                                      text:
                                          'Last Updated ${deviceDetailsController.lastUpdatedDate.value}',
                                      size: 14.0,
                                      fontWeight: FontWeight.w600,
                                      textColor: Colors.grey,
                                      fontFamily: 'karbon',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // second row
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                        child: CommonWidgets().text(
                                          text:
                                              'Model: ${deviceDetailsController.model.value != '' ? deviceDetailsController.model.value : '--'}',
                                          size: 14.0,
                                          fontWeight: FontWeight.w600,
                                          textColor: const Color.fromRGBO(
                                              88, 89, 91, 1),
                                          fontFamily: 'karbon',
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                        child: CommonWidgets().text(
                                          text:
                                              'Serial: ${deviceDetailsController.serial.value != '' ? deviceDetailsController.serial.value : '--'}',
                                          size: 14.0,
                                          fontWeight: FontWeight.w600,
                                          textColor: const Color.fromRGBO(
                                              88, 89, 91, 1),
                                          fontFamily: 'karbon',
                                        ),
                                      ),
                                      Obx(
                                        () => SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.1,
                                          child: Row(
                                            children: [
                                              CommonWidgets().text(
                                                text: 'Errors: ',
                                                size: 14.0,
                                                fontWeight: FontWeight.w600,
                                                textColor: const Color.fromRGBO(
                                                    88, 89, 91, 1),
                                                fontFamily: 'karbon',
                                              ),
                                              Obx(
                                                () {
                                                  return CommonWidgets().text(
                                                    text: deviceDetailsController
                                                                .activeError
                                                                .value ==
                                                            0.toString()
                                                        ? 'None'
                                                        : deviceDetailsController
                                                            .activeError.value,
                                                    size: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            88, 89, 91, 1),
                                                    fontFamily: 'Karbon',
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CommonWidgets().button(
                                      name: 'Advanced',
                                      function: () async {
                                        await timer.cancel();
                                        Get.to(
                                          () => const AdvancedSerach(),
                                        );
                                      },
                                      buttonColor:
                                          Theme.of(context).colorScheme.primary,
                                      width: 100.0,
                                      height: 52.0)
                                ],
                              ),
                            ),
                            // third row
                            Obx(
                              () {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .12,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      var values = deviceDetailsController
                                          .systemOperationsData.value
                                          .toJson()
                                          .values
                                          .toList();
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonWidgets().text(
                                            text: deviceDetailsController
                                                .systemModesLeading[i].leading,
                                            size: 16.0,
                                            fontWeight: FontWeight.w600,
                                            textColor: const Color.fromRGBO(
                                                88, 89, 91, 1),
                                            fontFamily: 'Karbon',
                                          ),
                                          Row(
                                            children: [
                                              deviceDetailsController
                                                          .systemModesLeading[i]
                                                          .type
                                                          .contains('r/w') &&
                                                      !deviceDetailsController
                                                          .systemModesLeading[i]
                                                          .select
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              CommonWidgets().registerEditDialog(
                                                                  context:
                                                                      context,
                                                                  data: data,
                                                                  label:
                                                                      'please enter ${deviceDetailsController.systemModesLeading[i].leading}',
                                                                  placeholder:
                                                                      deviceDetailsController
                                                                          .systemModesLeading[
                                                                              i]
                                                                          .leading,
                                                                  type: TextInputType
                                                                      .number,
                                                                  register:
                                                                      deviceDetailsController
                                                                          .systemModesLeading[
                                                                              i]
                                                                          .reg),
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        size: 14.0,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Obx(
                                                () => deviceDetailsController
                                                        .systemModesLeading[i]
                                                        .select
                                                    ? SizedBox(
                                                        height: 25.0,
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                            value:
                                                                deviceDetailsController
                                                                    .operationMode
                                                                    .value,
                                                            items:
                                                                operationModes
                                                                    .map((String
                                                                        item) {
                                                              return DropdownMenuItem(
                                                                value: item,
                                                                child:
                                                                    CommonWidgets()
                                                                        .text(
                                                                  text: item
                                                                      .toString(),
                                                                  size: 16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  textColor:
                                                                      Colors
                                                                          .black,
                                                                  fontFamily:
                                                                      'Karbon',
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (val) {
                                                              changeOperationMode(
                                                                reg: deviceDetailsController
                                                                    .systemModesLeading[
                                                                        i]
                                                                    .reg,
                                                                selectedValue:
                                                                    val,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : CommonWidgets().text(
                                                        text: values[i + 1],
                                                        size: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        textColor: const Color
                                                                .fromRGBO(
                                                            88, 89, 91, 1),
                                                        fontFamily: 'karbon',
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: deviceDetailsController
                                        .systemModesLeading.length,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),
                            Obx(
                              (() => CommonWidgets().text(
                                    text:
                                        'Status Flags: ${deviceDetailsController.statusFlagsData.value != '' ? deviceDetailsController.statusFlagsData.value : '--'}',
                                    size: 18.0,
                                    fontWeight: FontWeight.w800,
                                    textColor:
                                        const Color.fromRGBO(88, 89, 91, 1),
                                    fontFamily: 'karbon',
                                  )),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .65,
                              child: Obx(
                                () {
                                  return ListView.builder(
                                    controller: scrollControllerOne,
                                    itemCount: deviceDetailsController
                                        .systemOperationsLeading.length,
                                    itemBuilder: (context, i) {
                                      var values = deviceDetailsController
                                          .systemOperationsData.value
                                          .toJson()
                                          .values
                                          .toList();
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonWidgets().text(
                                            text: deviceDetailsController
                                                .systemOperationsLeading[i]
                                                .leading,
                                            size: 14.0,
                                            fontWeight: FontWeight.w400,
                                            textColor: const Color.fromRGBO(
                                                88, 89, 91, 1),
                                            fontFamily: 'Montserrat',
                                          ),
                                          Row(
                                            children: [
                                              deviceDetailsController
                                                          .systemOperationsLeading[
                                                              i]
                                                          .type
                                                          .contains('r/w') &&
                                                      !deviceDetailsController
                                                          .systemOperationsLeading[
                                                              i]
                                                          .toggleButton
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        data.text =
                                                            values[i + 6];
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              CommonWidgets().registerEditDialog(
                                                                  context:
                                                                      context,
                                                                  data: data,
                                                                  label:
                                                                      'please enter ${deviceDetailsController.systemOperationsLeading[i].leading}',
                                                                  placeholder:
                                                                      deviceDetailsController
                                                                          .systemOperationsLeading[
                                                                              i]
                                                                          .leading,
                                                                  type: TextInputType
                                                                      .number,
                                                                  register:
                                                                      deviceDetailsController
                                                                          .systemOperationsLeading[
                                                                              i]
                                                                          .reg,
                                                                  value: values[
                                                                      i + 6]),
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        size: 14.0,
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              const SizedBox(
                                                width: 15.0,
                                              ),
                                              Obx(
                                                () => deviceDetailsController
                                                        .systemOperationsLeading[
                                                            i]
                                                        .toggleButton
                                                    ? SizedBox(
                                                        height: 17.0,
                                                        width: 20.0,
                                                        child: Transform.scale(
                                                          scale: .7,
                                                          child: Switch(
                                                            value:
                                                                values[i + 6] ==
                                                                        'On'
                                                                    ? true
                                                                    : false,
                                                            activeColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                            activeTrackColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                            onChanged: (_) => toogleSwitch(
                                                                reg: deviceDetailsController
                                                                    .systemOperationsLeading[
                                                                        i]
                                                                    .reg,
                                                                bit: deviceDetailsController
                                                                    .systemOperationsLeading[
                                                                        i]
                                                                    .bit),
                                                          ),
                                                        ),
                                                      )
                                                    : CommonWidgets().text(
                                                        text: values[i + 6] ??
                                                            '--',
                                                        size: 13.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        textColor: const Color
                                                                .fromRGBO(
                                                            88, 89, 91, 1),
                                                        fontFamily: 'karbon',
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (deviceDetailsController.sysOpsDataLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }

  changeOperationMode({
    reg,
    selectedValue,
  }) async {
    var val;
    if (selectedValue == 'Off') {
      val = 0;
    } else if (selectedValue == 'Cool') {
      val = 2;
    } else if (selectedValue == 'Heat') {
      val = 4;
    } else if (selectedValue == 'Fan') {
      val = 8;
    } else if (selectedValue == 'Auto') {
      val = 16;
    }
    await PacketFrameService().createPacket(
      [
        1,
        12,
        val,
      ],
      PacketFrameController().subopcodeWriteSingle,
    );
  }

  toogleSwitch({
    reg,
    bit,
  }) async {
    var val;
    if (bit == 4) {
      val = 16;
    } else {
      val = 64;
    }
    await PacketFrameService().createPacket(
      [
        1,
        32,
        val,
      ],
      PacketFrameController().subopcodeWriteSingle,
    );
  }
}
