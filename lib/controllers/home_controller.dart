import 'package:get/get.dart';

class HomeController extends GetxController {
  List savedDevices = [].obs;
  List deviceSystemOperationsData = [].obs;
  List deviceSystemConfigData = [].obs;

  clearAllData() {
    savedDevices.isNotEmpty ? savedDevices.clear() : null;
    deviceSystemConfigData.isNotEmpty ? deviceSystemConfigData.clear() : null;
    deviceSystemOperationsData.isNotEmpty
        ? deviceSystemOperationsData.clear()
        : null;
  }
}
