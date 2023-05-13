import 'dart:async';
import 'dart:math';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/views/devices.dart';
import 'package:airlink/views/devices_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpritePainter extends CustomPainter {
  final Animation<double> _animation;

  SpritePainter(this._animation) : super(repaint: _animation);

  void circle(Canvas canvas, Rect rect, double value) {
    double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    Color color = Color.fromRGBO(16, 146, 222, opacity);

    double size = rect.width / 1.7;
    double area = size * size;
    double radius = sqrt(area * value / 2);
    Paint paintBorder = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      rect.center,
      radius,
      paintBorder,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return true;
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final bleController = Get.find<BleController>(tag: 'bleController');
  final homeController = Get.find<HomeController>(tag: 'homeController');
  var timer;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bleController.devicesFound.clear();
    });
    Future.delayed(
      const Duration(milliseconds: 3),
      () => {
        _controller
          ..stop()
          ..reset()
          ..repeat(
            period: const Duration(seconds: 2),
          ),
      },
    );
    fun();
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  fun() async {
    await BleService().scanDevice();
    homeController.isScanCanceled.value
        ? Get.to(
            () => const Devices(),
          )
        : Get.to(
            () => const DevicesFound(),
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    bleController.isConnectionCancled.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => const Devices());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CommonWidgets().text(
                  text: 'Searching for devices...',
                  size: 32.0,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.black,
                  fontFamily: 'Inter',
                ),
                CustomPaint(
                  painter: SpritePainter(_controller),
                  child: SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: Center(
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CommonWidgets().text(
                                  text: 'Actron',
                                  size: 28.0,
                                  fontWeight: FontWeight.w400,
                                  textColor: Colors.black,
                                  fontFamily: 'Karbon',
                                ),
                                CommonWidgets().text(
                                  text: 'Link',
                                  size: 28.0,
                                  fontWeight: FontWeight.w600,
                                  textColor: Colors.black,
                                  fontFamily: 'Karbon',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CommonWidgets().richText(
                    name: 'Cancel',
                    color: Colors.black,
                    function: () async {
                      print('canceled');
                      homeController.isScanCanceled.value = true;
                      Get.to(
                        () => const Devices(),
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        homeController.isScanCanceled.value = false;
                      });
                    },
                    size: 18.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
