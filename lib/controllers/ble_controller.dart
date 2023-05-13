import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BleController extends GetxController {
  BluetoothService? bluetoothServices;
  final currentAddress = ''.obs;
  final appVersion = ''.obs;
  final scanComplete = false.obs;
  final deviceVersion = '1.00.0001';
  late final BluetoothService service;
  BluetoothDevice? connectedDevice;
  BluetoothDevice? selectedDevice;
  late ChartSeriesController chartSeriesController;
  BluetoothCharacteristic? notifyCharacteristics;
  BluetoothCharacteristic? writeCharacteristics;
  final isConnectionCancled = false.obs;
  final isConnected = false.obs;
  final isRescan = false.obs;
  String selectedId = '';
  String commissionedDate = '';
  List<BluetoothDevice> localBluetoothDevices = [];
  String newDeviceName = '';
  List devicesFound = [].obs;
  List savedDevices = [].obs;
  double lan = 0.0;
  double lon = 0.0;

  void addDevices(final BluetoothDevice device) {
    devicesFound.add(device);
  }
}

class RegistersData {
  RegistersData(this.x, this.y);

  final int x;
  final double y;
}
