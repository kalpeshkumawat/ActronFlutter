import 'dart:async';
import 'dart:math';

import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/ble_controller.dart';
import '../../controllers/device_details_controller.dart';
import '../../services/ble_service.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final bleController = Get.find<BleController>(tag: 'bleController');
  bool play = true;
  List<Map<String, dynamic>> listOfBoxes = [
    {'colorOfBox': const Color(0xFFb76e6e), 'data': 'HP Pressure'},
    {'colorOfBox': const Color(0xFF7171b8), 'data': 'LP Pressure'},
    {'colorOfBox': Colors.green, 'data': 'Coil Temp'},
    {'colorOfBox': Colors.red, 'data': 'DLT Temp'},
    {'colorOfBox': const Color(0xFF6161ff), 'data': 'SCT Temp'},
    {'colorOfBox': const Color(0xFFff42ff), 'data': 'Superheat'},
    {'colorOfBox': Colors.cyan, 'data': 'Comp Speed'},
    {'colorOfBox': const Color(0xFFb9b975), 'data': 'EXV Opening'},
  ];
  Timer? timer;
  TransformationController? viewTransformationController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    deviceDetailsController.deviceDetailsPage.value = false;
    deviceDetailsController.operationsTillHpPressure.value = false;
    deviceDetailsController.operationsTillVsdMotor.value = false;
    deviceDetailsController.errorsCodesRegistry.value = false;
    deviceDetailsController.errorsDatesRegistry.value = false;
    deviceDetailsController.errorsTimesRegistry.value = false;
    deviceDetailsController.economiserSettingPage.value = false;
    deviceDetailsController.graphPage.value = true;
    deviceDetailsController.advancedSearchPage.value = false;
    playPauseTimer();
    // clearGraph();
    viewTransformationController = TransformationController();
    viewTransformationController!.value = Matrix4.identity() * 0.8;
    super.initState();
  }

  clearGraph() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      clearGraphData();
    });
  }

  clearGraphData() {
    deviceDetailsController.coilTempGraphData.clear();
    deviceDetailsController.dltTempGraphData.clear();
    deviceDetailsController.sctTempGraphData.clear();
    deviceDetailsController.superheatGraphData.clear();
    deviceDetailsController.exvOpeningGraphData.clear();
    deviceDetailsController.hpPressureGraphData.clear();
    deviceDetailsController.lpPressureGraphData.clear();
    deviceDetailsController.compSpeedGraphData.clear();
  }

  fetchGraphData() async {
    if (bleController.connectedDevice != null) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        BleService().sendPackets(150, packetFrameController.graphData);
      });
    }
  }

  playPauseTimer() {
    debugPrint('timer is ${timer.toString()}');
    play ? fetchGraphData() : timer!.cancel();
  }

  restartGraph() {
    clearGraphData();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    clearGraphData();
    deviceDetailsController.graphPage.value = false;
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int max = 10;
    Random rnd = Random();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'System Monitoring',
              textAlign: TextAlign.end,
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
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 82,
                  child: Container(
                    alignment: Alignment.center,
                    child: Obx(
                      () => Column(
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.shortestSide < 600
                                    ? MediaQuery.of(context).size.height * .75
                                    : 275,
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries>[
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group A',
                                      color: const Color(0xFFb76e6e),
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .hpPressureGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        return ChartData(
                                            e.key.toDouble(), e.value / 500);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group B',
                                      color: const Color(0xFF7171b8),
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .lpPressureGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        return ChartData(
                                            e.key.toDouble(), e.value / 500);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group C',
                                      color: Colors.green,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .coilTempGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        return ChartData(
                                            e.key.toDouble(), e.value / 10);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group D',
                                      color: Colors.red,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .dltTempGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        return ChartData(
                                            e.key.toDouble(), e.value / 10);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group E',
                                      color: const Color(0xFF6161ff),
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .sctTempGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        return ChartData(
                                            e.key.toDouble(), e.value / 10);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group F',
                                      color: const Color(0xFFff42ff),
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .superheatGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        return ChartData(
                                            e.key.toDouble(), e.value / 10);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group G',
                                      color: Colors.cyan,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .compSpeedGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                        return ChartData(
                                            e.key.toDouble(), e.value);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                  StackedLineSeries<ChartData, double>(
                                      groupName: 'Group H',
                                      color: const Color(0xFFb9b975),
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              useSeriesColor: true),
                                      dataSource: deviceDetailsController
                                          .exvOpeningGraphData
                                          .asMap()
                                          .entries
                                          .map((e) {
                                            debugPrint("${e.key.toDouble()} ${e.value / 5}");
                                        return ChartData(
                                            e.key.toDouble(), e.value / 5);
                                      }).toList(),
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y),
                                ]),
                          ),
/*
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .78,
                            child: AspectRatio(
                              aspectRatio: 4,
                              child: LineChart(
                                LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .coilTempGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Colors.red),
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .dltTempGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Colors.purple),
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .sctTempGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Colors.green),
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .superheatGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Colors.black),
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .exvOpeningGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Colors.amber),
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .compSpeedGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Colors.grey),
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .hpPressureGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Colors.orange),
                                    LineChartBarData(
                                        spots: deviceDetailsController
                                            .lpPressureGraphData
                                            .asMap()
                                            .entries
                                            .map((e) {
                                          return ChartData(
                                              e.key.toDouble(), e.value);
                                        }).toList(),
                                        isCurved: true,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ],
                                  titlesData: FlTitlesData(
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: false,
                                      ),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: false,
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    border: const Border(
                                      top: BorderSide(
                                        width: 0,
                                      ),
                                      right: BorderSide(
                                        width: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                swapAnimationCurve: Curves.linear,
                              ),
                            ),
                          ),
*/
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 18,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.shortestSide < 600
                              ? MediaQuery.of(context).size.height * .65
                              : 275,
                          child: ListView.builder(
                            itemCount: listOfBoxes.length,
                            itemBuilder: (BuildContext context, i) {
                              return GestureDetector(
                                onTap: () {
                                  debugPrint('tapped');
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      color: listOfBoxes[i]['colorOfBox'],
                                      width: 30.0,
                                      height: 10.0,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CommonWidgets().text(
                                      listOfBoxes[i]['data'],
                                      14.0,
                                      FontWeight.w400,
                                      TextAlign.start,
                                      Colors.black,
                                      'Karbon',
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                restartGraph();
                                setState(() {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 40.0),
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                play = !play;
                                setState(
                                  () => {},
                                );
                                playPauseTimer();
                              },
                              child: play
                                  ? const Icon(
                                      Icons.pause_circle,
                                      color: Colors.black,
                                      size: 30.0,
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;
}