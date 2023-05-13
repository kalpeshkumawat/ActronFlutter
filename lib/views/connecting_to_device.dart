import 'dart:async';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/views/connection_successfull.dart';
import 'package:airlink/views/devices_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class ConnectingToDevice extends StatefulWidget {
  const ConnectingToDevice({Key? key}) : super(key: key);

  @override
  State<ConnectingToDevice> createState() => _ConnectingToDeviceState();
}

class _ConnectingToDeviceState extends State<ConnectingToDevice> {
  final bleController = Get.find<BleController>(tag: 'bleController');

  late Timer timer;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      connect();
    });

    super.initState();
  }

  connect() async {
    await BleService().connectToDevice(bleController.selectedDevice!);
    if (await bleController.selectedDevice!.state.first ==
            BluetoothDeviceState.connected &&
        !bleController.isConnectionCancled.value) {
      Get.to(
        () => const ConnectionSuccessfull(),
      );
    } else if (bleController.isConnectionCancled.value) {
      BleService().disconnectToDevice(bleController.selectedDevice!);
      Get.to(
        () => const DevicesFound(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Pairing Device',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/phone.png'),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(188, 190, 192, .5),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  height: 6,
                  width: 6,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(188, 190, 192, .5),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  height: 6,
                  width: 6,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.bluetooth,
                  size: 38.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(188, 190, 192, .5),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  height: 6,
                  width: 6,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(188, 190, 192, .5),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  height: 6,
                  width: 6,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Image.asset('assets/link.png'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Center(
                child: CommonWidgets().richText(
                    name: 'Cancel',
                    color: Colors.black,
                    function: () async {
                      bleController.isConnectionCancled.value = true;
                      Get.to(
                        () => const DevicesFound(),
                      );
                    },
                    size: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
