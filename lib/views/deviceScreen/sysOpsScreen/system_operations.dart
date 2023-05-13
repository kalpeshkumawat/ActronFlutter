import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/models/sysops_data_model.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/views/deviceScreen/device_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/packet_frame_controller.dart';
import '../../../services/packet_frame_service.dart';
import 'advanced_search.dart';

class SystemOperations extends StatefulWidget {
  const SystemOperations({Key? key}) : super(key: key);

  @override
  State<SystemOperations> createState() => _SystemOperationsState();
}

class _SystemOperationsState extends State<SystemOperations> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  final ScrollController scrollControllerOne = ScrollController();
  final ScrollController scrollControllerTwo = ScrollController();
  TextEditingController data = TextEditingController();
  var timer;
  var operationModes = ['', 'Off', 'Cool', 'Heat', 'Fan', 'Auto'];

  @override
  void initState() {
    deviceDetailsController.deviceDetailsPage.value = false;
    deviceDetailsController.operationsTillHpPressure.value = true;
    deviceDetailsController.operationsTillVsdMotor.value = true;
    deviceDetailsController.errorsCodesRegistry.value = false;
    deviceDetailsController.errorsDatesRegistry.value = false;
    deviceDetailsController.errorsTimesRegistry.value = false;
    deviceDetailsController.economiserSettingPage.value = false;
    deviceDetailsController.graphPage.value = false;
    deviceDetailsController.advancedSearchPage.value = false;
    deviceDetailsController.activeErrorsRegistry.value = false;
    deviceDetailsController.statusFlagsData.value = '';
    if (bleController.connectedDevice != null) {
      bleController.connectedDevice!.requestMtu(128).whenComplete(() async {});
      timer = Timer.periodic(
        const Duration(seconds: 5),
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
    deviceDetailsController.operationsTillHpPressure.value = false;
    deviceDetailsController.operationsTillVsdMotor.value = false;
    timer.cancel();
    super.dispose();
  }

  getSystemOperationsData() async {
    for (var element in bleController.savedDevices) {
      if (element['id'] == bleController.selectedId) {
        var sysOpsData = element['systemOperations']
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',');
        sysOpsData.forEach((element) {
          Map<String, dynamic> mySysData =
              jsonDecode(element.replaceAll("'", "\""));
          debugPrint('data is in $mySysData');
          deviceDetailsController.updateSystemOperationsData(
              SystemOperationRegisterModels(
                  leading: mySysData.keys.first,
                  trailing: mySysData.values.first));
        });
        var sysOpsModesAndSpeeds = element['systemOperationsModesAndSpeeds']
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',');

        sysOpsModesAndSpeeds.forEach((element) {
          Map<String, dynamic> myData =
              jsonDecode(element.replaceAll("'", "\""));
          deviceDetailsController.updateSystemOperationsModesAndSpeeds(
            SystemOperationRegisterModels(
                leading: myData.keys.first, trailing: myData.values.first),
          );
        });
        inspect(deviceDetailsController.systemOperationsModesAndSpeeds);
      }
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
              await timer.cancel();
              Get.to(
                () => const DeviceDeatails(),
              );
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
                                          bleController.selectedDevice != null
                                              ? bleController
                                                  .selectedDevice!.name
                                              : '',
                                          24,
                                          FontWeight.bold,
                                          TextAlign.start,
                                          const Color.fromRGBO(65, 64, 66, 1),
                                          'karbon'),
                                    ),
                                    CommonWidgets().text(
                                        'Last Updated 2022 April 16 16:44',
                                        14,
                                        FontWeight.w600,
                                        TextAlign.start,
                                        Colors.grey,
                                        'karbon'),
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
                                            'Model: ${deviceDetailsController.model.value != '' ? deviceDetailsController.model.value : '--'}',
                                            14,
                                            FontWeight.w600,
                                            TextAlign.start,
                                            const Color.fromRGBO(88, 89, 91, 1),
                                            'karbon'),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                        child: CommonWidgets().text(
                                            'Serial: ${deviceDetailsController.serial.value != '' ? deviceDetailsController.serial.value : '--'}',
                                            14,
                                            FontWeight.w600,
                                            TextAlign.start,
                                            const Color.fromRGBO(88, 89, 91, 1),
                                            'karbon'),
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
                                                  'Errors: ',
                                                  14.0,
                                                  FontWeight.w600,
                                                  TextAlign.end,
                                                  const Color.fromRGBO(
                                                      88, 89, 91, 1),
                                                  'karbon'),
                                              CommonWidgets().text(
                                                  deviceDetailsController
                                                              .activeError
                                                              .value ==
                                                          0.toString()
                                                      ? 'None'
                                                      : deviceDetailsController
                                                          .activeError.value,
                                                  14.0,
                                                  FontWeight.w600,
                                                  TextAlign.start,
                                                  const Color.fromRGBO(
                                                      88, 89, 91, 1),
                                                  'Karbon'),
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
                                      width: 170.0,
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
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonWidgets().text(
                                              deviceDetailsController
                                                  .systemOperationsModesAndSpeeds[
                                                      i]
                                                  .leading,
                                              16.0,
                                              FontWeight.w600,
                                              TextAlign.start,
                                              const Color.fromRGBO(
                                                  88, 89, 91, 1),
                                              'Karbon'),
                                          Row(
                                            children: [
                                              deviceDetailsController
                                                          .systemOperationsModesAndSpeeds[
                                                              i]
                                                          .type
                                                          .contains('r/w') &&
                                                      deviceDetailsController
                                                          .systemOperationsData[
                                                              i]
                                                          .select
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) => CommonWidgets().registerEditDialog(
                                                              context: context,
                                                              data: data,
                                                              label:
                                                                  'please enter ${deviceDetailsController.systemOperationsModesAndSpeeds[i].leading}',
                                                              placeholder:
                                                                  deviceDetailsController
                                                                      .systemOperationsModesAndSpeeds[
                                                                          i]
                                                                      .leading,
                                                              type: const TextInputType
                                                                      .numberWithOptions(
                                                                  decimal: true,
                                                                  signed:
                                                                      false),
                                                              register:
                                                                  deviceDetailsController
                                                                      .systemOperationsModesAndSpeeds[
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
                                                        .systemOperationsModesAndSpeeds[
                                                            i]
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
                                                                  item.toString(),
                                                                  16.0,
                                                                  FontWeight
                                                                      .w600,
                                                                  TextAlign
                                                                      .center,
                                                                  Colors.black,
                                                                  'Karbon',
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (val) {
                                                              changeOperationMode(
                                                                reg: deviceDetailsController
                                                                    .systemOperationsModesAndSpeeds[
                                                                        i]
                                                                    .reg,
                                                                selectedValue:
                                                                    val,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : Obx(
                                                        (() => CommonWidgets().text(
                                                            deviceDetailsController
                                                                .systemOperationsModesAndSpeeds[
                                                                    i]
                                                                .trailing,
                                                            16.0,
                                                            FontWeight.w600,
                                                            TextAlign.center,
                                                            const Color
                                                                    .fromRGBO(
                                                                88, 89, 91, 1),
                                                            'karbon')),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: deviceDetailsController
                                        .systemOperationsModesAndSpeeds.length,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(
                              height: 10.0,
                            ),
                            Obx(
                              (() => CommonWidgets().text(
                                  'Status Flags: ${deviceDetailsController.statusFlagsData.value != '' ? deviceDetailsController.statusFlagsData.value : '--'}',
                                  18.0,
                                  FontWeight.w800,
                                  TextAlign.center,
                                  const Color.fromRGBO(88, 89, 91, 1),
                                  'karbon')),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .65,
                              child: ListView.builder(
                                controller: scrollControllerOne,
                                itemCount: deviceDetailsController
                                    .systemOperationsData.length,
                                itemBuilder: (context, i) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonWidgets().text(
                                          deviceDetailsController
                                              .systemOperationsData[i].leading,
                                          14.0,
                                          FontWeight.w400,
                                          TextAlign.start,
                                          const Color.fromRGBO(88, 89, 91, 1),
                                          'Montserrat'),
                                      Row(
                                        children: [
                                          deviceDetailsController
                                                      .systemOperationsData[i]
                                                      .type
                                                      .contains('r/w') &&
                                                  !deviceDetailsController
                                                      .systemOperationsData[i]
                                                      .toggleButton
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          CommonWidgets().registerEditDialog(
                                                              context: context,
                                                              data: data,
                                                              label:
                                                                  'please enter ${deviceDetailsController.systemOperationsData[i].leading}',
                                                              placeholder:
                                                                  deviceDetailsController
                                                                      .systemOperationsData[
                                                                          i]
                                                                      .leading,
                                                              type: const TextInputType
                                                                      .numberWithOptions(
                                                                  decimal: true,
                                                                  signed:
                                                                      false),
                                                              register:
                                                                  deviceDetailsController
                                                                      .systemOperationsData[
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
                                            width: 15.0,
                                          ),
                                          Obx(
                                            () => deviceDetailsController
                                                    .systemOperationsData[i]
                                                    .toggleButton
                                                ? SizedBox(
                                                    height: 17.0,
                                                    width: 20.0,
                                                    child: Transform.scale(
                                                      scale: .7,
                                                      child: Switch(
                                                        value: deviceDetailsController
                                                                    .systemOperationsData[
                                                                        i]
                                                                    .trailing ==
                                                                'On'
                                                            ? true
                                                            : false,
                                                        activeColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        activeTrackColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        onChanged: (_) => toogleSwitch(
                                                            reg: deviceDetailsController
                                                                .systemOperationsData[
                                                                    i]
                                                                .reg,
                                                            bit: deviceDetailsController
                                                                .systemOperationsData[
                                                                    i]
                                                                .bit),
                                                      ),
                                                    ),
                                                  )
                                                : CommonWidgets().text(
                                                    deviceDetailsController
                                                        .systemOperationsData[i]
                                                        .trailing,
                                                    14.0,
                                                    FontWeight.w600,
                                                    TextAlign.center,
                                                    const Color.fromRGBO(
                                                        88, 89, 91, 1),
                                                    'karbon'),
                                          ),
                                        ],
                                      ),
                                    ],
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

  changeOperationMode({reg, selectedValue}) async {
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

  toogleSwitch({reg, bit}) async {
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
