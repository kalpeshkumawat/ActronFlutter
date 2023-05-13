import 'dart:async';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/views/devices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ble_controller.dart';
import '../controllers/system_configuration_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  States currentVisible = States.none;
  final bleController = Get.put(BleController(), tag: 'bleController');
  final systemConfigurationController = Get.put(SystemConfigurationController(),
      tag: 'systemConfigurationController');
  final homeController = Get.put(HomeController(), tag: 'homeController');
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Get.to(
        () => const Devices(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Image.asset(
              'assets/logo-black.png',
              height: 45,
              width: Get.width * .6,
            ),
          ),
        ),
      ),
    );
  }
}

enum States { none, bottom, middle, top }
