import 'dart:async';
import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/models/chart_data_model.dart';
import 'package:airlink/services/device_details_service.dart';
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
  late TooltipBehavior _tooltipBehavior;

  late ChartSeriesController _chartSeriesController;
  late ZoomPanBehavior _zoomPanBehavior;
  bool isPause = false;
  Stream? myStream;
  StreamSubscription? myStreamSubscription;
  TransformationController? viewTransformationController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
    DeviceDetailsService().managingPages(pageNumber: 5);
    if (bleController.connectedDevice != null) {
      myStream = Stream.periodic(
        const Duration(seconds: 5),
        (value) {
          BleService().sendPackets(150, packetFrameController.graphData);
          if (mounted) {
            setState(() {});
          }
        },
      );
      myStreamSubscription = myStream!.listen((event) {});
    }
    clearGraph();
    viewTransformationController = TransformationController();
    super.initState();
  }

  clearGraph() {
    Timer.periodic(const Duration(minutes: 5), (timer) {
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
    deviceDetailsController.wholeChartData.clear();
  }

  playPauseTimer() {
    isPause ? myStreamSubscription!.pause() : myStreamSubscription!.resume();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            return Scrollbar(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .6,
                          child: SfCartesianChart(
                            legend: Legend(isVisible: true),
                            zoomPanBehavior: ZoomPanBehavior(
                                enableDoubleTapZooming: true,
                                enablePanning: true,
                                enablePinching: true,
                                enableSelectionZooming: true),
                            tooltipBehavior: _tooltipBehavior,
                            primaryXAxis: CategoryAxis(),
                            series: <LineSeries<ChartData, int>>[
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Comp speed graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromRGBO(192, 108, 132, 1),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.compSpeedGraphData,
                              ),
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Coil temp graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromARGB(255, 163, 4, 49),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.coilTempGraphData,
                              ),
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Dlt temp graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromARGB(255, 7, 192, 84),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.dltTempGraphData,
                              ),
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Sct temp graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromARGB(255, 4, 39, 155),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.sctTempGraphData,
                              ),
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Super heat graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromARGB(255, 207, 8, 131),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.superheatGraphData,
                              ),
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Exv opening graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromARGB(255, 8, 8, 8),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.exvOpeningGraphData,
                              ),
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Hp pressure graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromARGB(255, 196, 152, 7),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.hpPressureGraphData,
                              ),
                              LineSeries<ChartData, int>(
                                onRendererCreated:
                                    (ChartSeriesController controller) {
                                  _chartSeriesController = controller;
                                },
                                enableTooltip: true,
                                name: 'Lp pressure graphdata',
                                dataSource:
                                    deviceDetailsController.wholeChartData,
                                color: const Color.fromARGB(255, 1, 88, 52),
                                xValueMapper: (ChartData data, _) => data.index,
                                yValueMapper: (ChartData data, _) =>
                                    data.lpPressureGraphData,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                restartGraph();
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.black,
                                size: 30.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                isPause = !isPause;
                                setState(
                                  () => {},
                                );
                                playPauseTimer();
                              },
                              child: isPause
                                  ? const Icon(
                                      Icons.play_circle,
                                      color: Colors.black,
                                      size: 30.0,
                                    )
                                  : const Icon(
                                      Icons.pause_circle,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // ),
              ),
            );
          },
        ),
      ),
    );
  }
}
