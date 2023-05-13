import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
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
                  text: 'Pairing Succesful',
                  size: 32.0,
                  fontWeight: FontWeight.bold,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Inter',
                ),
              ),
              Image.asset('assets/checked.png'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: CommonWidgets().button(
                    name: 'Next',
                    function: () {
                      bleController.connectedDevice!
                          .requestMtu(256)
                          .whenComplete(() async {});

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
