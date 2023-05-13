import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/device_details_controller.dart';

class ErrorHistory extends StatefulWidget {
  const ErrorHistory({Key? key}) : super(key: key);

  @override
  State<ErrorHistory> createState() => _ErrorHistoryState();
}

class _ErrorHistoryState extends State<ErrorHistory> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  @override
  void initState() {
    deviceDetailsController.deviceDetailsPage.value = false;
    deviceDetailsController.operationsTillHpPressure.value = false;
    deviceDetailsController.operationsTillVsdMotor.value = false;
    deviceDetailsController.errorsCodesRegistry.value = true;
    deviceDetailsController.economiserSettingPage.value = false;
    deviceDetailsController.graphPage.value = false;
    deviceDetailsController.advancedSearchPage.value = false;
    deviceDetailsController.errorCodes.clear();
    deviceDetailsController.errorDates.clear();
    deviceDetailsController.errorTimes.clear();
    if (bleController.connectedDevice != null) {
      bleController.connectedDevice!.requestMtu(256);
      BleService().sendPackets(150, packetFrameController.errorCodes1);
      deviceDetailsController.errorsTimesRegistry.value = true;
      BleService().sendPackets(300, packetFrameController.errorTime);
      deviceDetailsController.errorsDatesRegistry.value = true;
      BleService().sendPackets(450, packetFrameController.errorDate);
    } else {
      getErrorHistory();
    }
    super.initState();
  }

  getErrorHistory() async {
    for (var element in bleController.savedDevices) {
      debugPrint('id is ${bleController.selectedId}');
      if (element['id'] == bleController.selectedId) {
        var errorCodes = element['errorCodes']
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',');
        var errorTimes = element['errorTimes']
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',');
        var errorDates = element['errorDates']
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',');
        for (var i = 0; i < errorCodes.length; i++) {
          deviceDetailsController.errorCodes.add(errorCodes[i]);
          deviceDetailsController.errorDates.add(errorDates[i]);
          deviceDetailsController.errorTimes.add(errorTimes[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'Error History',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => {
              Get.back(),
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CommonWidgets().text('Active Error: ', 16.0,
                        FontWeight.w600, TextAlign.end, Colors.black, 'karbon'),
                    Obx(
                      () {
                        return CommonWidgets().text(
                            deviceDetailsController.activeError.value ==
                                    0.toString()
                                ? 'None'
                                : deviceDetailsController.activeError.value,
                            16.0,
                            FontWeight.w700,
                            TextAlign.end,
                            Colors.green,
                            'karbon');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CommonWidgets().text('Error Code', 14.0,
                        FontWeight.w600, TextAlign.left, Colors.grey, 'karbon'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: CommonWidgets().text('Error Description', 14,
                      FontWeight.w600, TextAlign.center, Colors.grey, 'karbon'),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: CommonWidgets().text('Error Time', 14.0,
                        FontWeight.w600, TextAlign.left, Colors.grey, 'karbon'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .77,
              child: Obx(
                () => deviceDetailsController.errorCodes.isNotEmpty
                    ? ListView.builder(
                        itemCount: deviceDetailsController.errorCodes.length,
                        itemBuilder: (context, i) {
                          return Container(
                            color: (i % 2 == 0)
                                ? const Color.fromRGBO(255, 255, 255, 1)
                                : const Color.fromRGBO(249, 249, 249, 1),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: CommonWidgets().text(
                                              'E${deviceDetailsController.errorCodes[i].toString()}',
                                              14.0,
                                              FontWeight.w600,
                                              TextAlign.left,
                                              Colors.black,
                                              'karbon'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 70,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: CommonWidgets().text(
                                            deviceDetailsController
                                                        .errorCodes[i]
                                                        .toString() ==
                                                    '0'
                                                ? 'No Error'
                                                : 'Outdoor Coil Sensor Error',
                                            14,
                                            FontWeight.w600,
                                            TextAlign.center,
                                            const Color.fromRGBO(73, 73, 73, 1),
                                            'karbon'),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30.0),
                                        child: Text(
                                          '${deviceDetailsController.errorDates[i].toString()}  ${deviceDetailsController.errorTimes[i].toString()}',
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Color.fromRGBO(73, 73, 73, 1),
                                              fontFamily: 'karbon'),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
