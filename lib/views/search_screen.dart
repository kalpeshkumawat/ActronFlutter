import 'dart:async';
import 'dart:math';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
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
    timer = Timer(
      const Duration(seconds: 5),
      () {
        Get.to(
          () => const DevicesFound(),
        );
      },
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CommonWidgets().text('Searching for devices...', 32.0,
                  FontWeight.bold, TextAlign.center, Colors.black, 'Inter'),
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
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Row(
                            children: [
                              CommonWidgets().text(
                                  'Actron',
                                  28.0,
                                  FontWeight.w400,
                                  TextAlign.center,
                                  Colors.black,
                                  'Karbon'),
                              CommonWidgets().text(
                                  'Link',
                                  28.0,
                                  FontWeight.w600,
                                  TextAlign.center,
                                  Colors.black,
                                  'Karbon'),
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
                    timer.cancel();
                    Get.to(
                      () => const Devices(),
                    );
                  },
                  size: 18.0),
            ],
          ),
        ),
      ),
    );
  }
}
