import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/services/device_details_service.dart';
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
  final homeController = Get.find<HomeController>(tag: 'homeController');
  @override
  void initState() {
    DeviceDetailsService().managingPages(pageNumber: 7);
    deviceDetailsController.errorCodes.clear();
    deviceDetailsController.errorDates.clear();
    deviceDetailsController.errorTimes.clear();
    if (bleController.connectedDevice != null) {
      bleController.connectedDevice!.requestMtu(256);
      BleService().sendPackets(150, packetFrameController.errorTime);
      DeviceDetailsService().managingPages(pageNumber: 8);
      BleService().sendPackets(300, packetFrameController.errorDate);
      DeviceDetailsService().managingPages(pageNumber: 6);
      BleService().sendPackets(450, packetFrameController.errorCodes);
    } else {
      getErrorHistory();
    }
    super.initState();
  }

  getErrorHistory() async {
    for (var element in homeController.errorCodes) {
      for (var ele in element) {
        deviceDetailsController.errorCodes.add(ele);
      }
    }
    for (var element in homeController.errorDates) {
      for (var ele in element) {
        deviceDetailsController.errorDates.add(ele);
      }
    }
    for (var element in homeController.errorTimes) {
      for (var ele in element) {
        deviceDetailsController.errorTimes.add(ele);
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
                    CommonWidgets().text(
                      text: 'Active Error: ',
                      size: 16.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.black,
                      fontFamily: 'karbon',
                    ),
                    Obx(
                      () {
                        return CommonWidgets().text(
                          text: deviceDetailsController.activeError.value ==
                                  0.toString()
                              ? 'None'
                              : deviceDetailsController.activeError.value,
                          size: 16.0,
                          fontWeight: FontWeight.w700,
                          textColor: Colors.green,
                          fontFamily: 'karbon',
                        );
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
                    child: CommonWidgets().text(
                      text: 'Error Code',
                      size: 14.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.grey,
                      fontFamily: 'karbon',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: CommonWidgets().text(
                    text: 'Error Description',
                    size: 14.0,
                    fontWeight: FontWeight.w600,
                    textColor: Colors.grey,
                    fontFamily: 'karbon',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: CommonWidgets().text(
                      text: 'Error Time',
                      size: 14.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.grey,
                      fontFamily: 'karbon',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .77,
              child: Obx(
                () => deviceDetailsController.isNoErrors.value
                    ? buildErrorsTable(
                        itemCount: deviceDetailsController.noErrorCodes.length,
                        errorCodes: deviceDetailsController.noErrorCodes,
                      )
                    : deviceDetailsController.errorCodes.isNotEmpty
                        ? buildErrorsTable(
                            itemCount:
                                deviceDetailsController.errorCodes.length,
                            errorCodes: deviceDetailsController.errorCodes,
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

  Widget buildErrorsTable({required int itemCount, required List errorCodes}) {
    print('length is $itemCount');
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, i) {
        return Container(
          color: (i % 2 == 0)
              ? const Color.fromRGBO(255, 255, 255, 1)
              : const Color.fromRGBO(249, 249, 249, 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonWidgets().text(
                          text: 'E${errorCodes[i].toString()}',
                          size: 14.0,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.black,
                          fontFamily: 'karbon',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: CommonWidgets().text(
                        text: errorCodes[i].toString() == '0'
                            ? 'No Error'
                            : errorCodes[i].toString() == '7'
                                ? 'Outdoor Coil Sensor Error'
                                : errorCodes[i].toString() == '43'
                                    ? 'Envelope Protection Error(High compression ratio)'
                                    : errorCodes[i].toString() == '44'
                                        ? 'Envelope Protection Error (High condensing pressure)'
                                        : 'No description',
                        size: 14.0,
                        fontWeight: FontWeight.w600,
                        textColor: const Color.fromRGBO(73, 73, 73, 1),
                        fontFamily: 'karbon',
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Text(
                        '${deviceDetailsController.errorDates[i].toString()}  ${deviceDetailsController.errorTimes[i].toString()}',
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(73, 73, 73, 1),
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
    );
  }
}
