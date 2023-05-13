import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../controllers/ble_controller.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({Key? key}) : super(key: key);

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final bleController = Get.find<BleController>(tag: 'bleController');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonWidgets().text('ActronLink Pairing', 32.0, FontWeight.bold,
                  TextAlign.center, Colors.black, 'Inter'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: CommonWidgets().text(
                    'Make Sure the AirLink device is connected to the outdoor board and Bluetooth has been enabled on your phone or tablet',
                    16.0,
                    FontWeight.normal,
                    TextAlign.center,
                    Colors.grey,
                    'karbon'),
              ),
              Image.asset(
                'assets/pairing.png',
                width: 261.0,
                height: 189,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: CommonWidgets().text(
                    'Please note that the serial number for your AirLink can be located on the bottom of the device',
                    16.0,
                    FontWeight.normal,
                    TextAlign.center,
                    Colors.grey,
                    'karbon'),
              ),
              CommonWidgets().button(
                  name: 'Search for devices',
                  function: () async {
                    if (await FlutterBluePlus.instance.isOn == false) {
                      CommonWidgets().errorSnackbar(
                        title: 'Bluetooth',
                        message: 'Please Turn On bluetooth',
                      );
                    } else {
                      Get.to(
                        () => const SearchScreen(),
                      );
                    }
                  },
                  buttonColor: Theme.of(context).colorScheme.primary,
                  width: 160.0,
                  height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}
