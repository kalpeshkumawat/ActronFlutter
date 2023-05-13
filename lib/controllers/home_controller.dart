import 'package:airlink/models/device_details_model.dart';
import 'package:airlink/models/error_model.dart';
import 'package:airlink/models/system_config_model.dart';
import 'package:airlink/models/system_operations_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final savedDevices = <DeviceDetailsModel>[].obs;
  final deviceSystemOperationsData = <SystemOperationsModel>[].obs;
  final deviceSystemConfigData = <SystemConfigModel>[].obs;
  final deviceErrorData = <DeviceErrorsModel>[].obs;
  final errorCodes = [].obs;
  final errorDates = [].obs;
  final errorTimes = [].obs;
  final isScanCanceled = false.obs;

  clearAllData() {
    savedDevices.isNotEmpty ? savedDevices.clear() : null;

    deviceSystemConfigData.isNotEmpty ? deviceSystemConfigData.clear() : null;

    deviceSystemOperationsData.isNotEmpty
        ? deviceSystemOperationsData.clear()
        : null;
  }
}
