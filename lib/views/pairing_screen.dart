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
              CommonWidgets().text(
                  text: 'ActronLink Pairing',
                  size: 32.0,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.black,
                  fontFamily: 'Inter'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: CommonWidgets().text(
                  text:
                      'Make sure the ActronLink device is connected to the outdoor board and Bluetooth has been enabled on your phone or tablet',
                  size: 16.0,
                  fontWeight: FontWeight.normal,
                  textColor: Colors.grey,
                  fontFamily: 'karbon',
                ),
              ),
              Image.asset(
                'assets/pairing.png',
                width: 261.0,
                height: 189,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: CommonWidgets().text(
                  text:
                      'Please note that the serial number for your ActronLink can be located on the bottom of the device',
                  size: 16.0,
                  fontWeight: FontWeight.normal,
                  textColor: Colors.grey,
                  fontFamily: 'karbon',
                ),
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
