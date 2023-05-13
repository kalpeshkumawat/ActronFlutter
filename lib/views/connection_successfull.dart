import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import 'deviceScreen/device_details.dart';

class ConnectionSuccessfull extends StatefulWidget {
  const ConnectionSuccessfull({Key? key}) : super(key: key);

  @override
  State<ConnectionSuccessfull> createState() => _ConnectionSuccessfullState();
}

class _ConnectionSuccessfullState extends State<ConnectionSuccessfull> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: CommonWidgets().text(
                    'Pairing Succesful',
                    32.0,
                    FontWeight.bold,
                    TextAlign.center,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Inter'),
              ),
              Image.asset('assets/checked.png'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: CommonWidgets().button(
                    name: 'Next',
                    function: () {
                      bleController.connectedDevice!
                          .requestMtu(256)
                          .whenComplete(() async {
                        var mtuSize =
                            await bleController.connectedDevice!.mtu.first;
                        debugPrint('mtu size is $mtuSize');
                      });
                      Future.delayed(const Duration(milliseconds: 200), () {
                        Get.to(
                          () => const DeviceDeatails(),
                        );
                      });
                    },
                    buttonColor: Theme.of(context).colorScheme.primary,
                    width: 100.0,
                    height: 48.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
