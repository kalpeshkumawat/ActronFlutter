import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/controllers/search_list_controller.dart';
import 'package:airlink/controllers/system_configuration_controller.dart';
import 'package:airlink/models/chart_data_model.dart';
import 'package:airlink/services/advanced_search_service.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/services/system_config_services.dart';
import 'package:airlink/services/system_operation_services.dart';
import 'package:get/get.dart';

class DeviceDetailsService {
  static final DeviceDetailsService _deviceDetailsService =
      DeviceDetailsService._internal();

  factory DeviceDetailsService() {
    return _deviceDetailsService;
  }

  DeviceDetailsService._internal();

  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');
  final packetFrameController =
      Get.find<PacketFrameController>(tag: 'packetFrameController');
  final searchListController =
      Get.put(SearchListController(), tag: 'searchListController');

  checkingPresentPage(reg, val, event) {
    if (deviceDetailsController.deviceDetailsPage.value) {
      addDeviceDetailsData(reg, val);
    }
    if (deviceDetailsController.systemOperationsPage.value) {
      SystemOperationServices().addSystemOperationValues(reg, val);
    }
    if (deviceDetailsController.errorsCodesRegistry.value) {
      if (reg == 1600 && val == 0) {
        deviceDetailsController.isNoErrors.value = true;
        deviceDetailsController.noErrorsRegistry.value = true;
        BleService().sendPackets(100, packetFrameController.noErrorCodes);
      } else {
        addErrors(reg, val, deviceDetailsController.errorCodes);
      }
    }
    if (deviceDetailsController.noErrorsRegistry.value) {
      if (reg == 51 || reg == 52 || reg == 53 || reg == 54 || reg == 55) {
        addErrors(reg, val, deviceDetailsController.noErrorCodes);
      }
    }
    if (deviceDetailsController.errorsDatesRegistry.value) {
      addErrors(reg, val, deviceDetailsController.errorDates);
    }
    if (deviceDetailsController.errorsTimesRegistry.value) {
      addErrors(reg, val, deviceDetailsController.errorTimes);
    }
    if (deviceDetailsController.activeErrorsRegistry.value) {
      deviceDetailsController.activeError.value = val.toString();
    }
    if (deviceDetailsController.graphPage.value) {
      addGraphsData(reg, val);
    }
    if (deviceDetailsController.systemConfigurePage.value) {
      SystemConfigServices().addSystemConfigurationValues(reg, val);
    }
    if (deviceDetailsController.advancedSearchPage.value) {
      AdvancedSearchService().addAdvanceSearchValues(reg, val, event);
    }
  }

  addErrors(reg, val, controller) {
    controller.add(val);
  }

  formGraphData() {
    if (deviceDetailsController.graphPage.value) {
      if (deviceDetailsController.compSpeedGraphData.isNotEmpty) {
        int index = deviceDetailsController.compSpeedGraphData.length - 1;
        deviceDetailsController.wholeChartData.add(ChartData(
            deviceDetailsController.coilTempGraphData[index],
            deviceDetailsController.compSpeedGraphData[index],
            deviceDetailsController.dltTempGraphData[index],
            deviceDetailsController.sctTempGraphData[index],
            deviceDetailsController.superheatGraphData[index],
            deviceDetailsController.exvOpeningGraphData[index] / 500,
            deviceDetailsController.hpPressureGraphData[index] / 5000,
            deviceDetailsController.lpPressureGraphData[index] / 5000,
            index));
      }
    }
  }

  addGraphsData(reg, val) {
    if (reg == 13) {
      deviceDetailsController.compSpeedGraphData.add(
        val.toDouble(),
      );
    }
    if (reg == 21) {
      deviceDetailsController.coilTempGraphData.add(val.toDouble());
      // deviceDetailsController.chartSeriesController.updateDataSource();
    }
    if (reg == 24) {
      deviceDetailsController.dltTempGraphData.add(val.toDouble());
    }
    if (reg == 25) {
      deviceDetailsController.sctTempGraphData.add(val.toDouble());
    }
    if (reg == 47) {
      deviceDetailsController.superheatGraphData.add(val.toDouble());
    }
    if (reg == 35) {
      deviceDetailsController.exvOpeningGraphData.add(val.toDouble());
    }
    if (reg == 28) {
      deviceDetailsController.hpPressureGraphData.add(val.toDouble());
    }
    if (reg == 29) {
      deviceDetailsController.lpPressureGraphData.add(val.toDouble());
    }
  }

  changeRegToString(int register) {
    var chars = [];
    var highC = (register & 0xFF00) >> 8;
    if (highC != 0) {
      chars.add(
        String.fromCharCode(
          highC,
        ),
      );
    }
    var lowC = register & 0xFF;
    if (lowC != 0) {
      chars.add(
        String.fromCharCode(
          lowC,
        ),
      );
    }
    return (chars);
  }

  addDeviceDetailsData(reg, val) {
    // please do add indoor serail and model packetes in packet controller and the receving funtionality here.
    if (reg == 1013 ||
        reg == 1014 ||
        reg == 1015 ||
        reg == 1016 ||
        reg == 1017 ||
        reg == 1018 ||
        reg == 1019) {
      List changedVal = val != 0 ? changeRegToString(val) : ['', ''];
      var firstVal = changedVal[0];
      var secondVal = changedVal[1];
      deviceDetailsController.model.value +=
          firstVal.toString() + secondVal.toString();
      for (var element in searchListController.searchList) {
        if (element.name == 'ODU Model') {
          element.value += firstVal.toString() + secondVal.toString();
        }
      }
    } else if (reg == 1010 || reg == 1011 || reg == 1012) {
      List changedVal = val != 0 ? changeRegToString(val) : ['', ''];
      var firstVal = changedVal[0];
      var secondVal = changedVal[1];
      for (var element in searchListController.searchList) {
        if (element.name == 'ODU Serial') {
          element.value += firstVal.toString() + secondVal.toString();
        }
      }
      deviceDetailsController.serial.value +=
          firstVal.toString() + secondVal.toString();
    } else if (reg == 4) {
      deviceDetailsController.oduVersion.value += val.toString();
    } else if (reg == 115) {
      deviceDetailsController.iduVersion.value += val.toString();
    }
  }

  managingPages({required int pageNumber}) {
    switch (pageNumber) {
      case 1:
        deviceDetailsController.deviceDetailsPage.value = true;
        break;
      case 2:
        deviceDetailsController.systemOperationsPage.value = true;
        deviceDetailsController.statusFlagsData.value = '';
        break;
      case 3:
        deviceDetailsController.advancedSearchPage.value = true;
        break;
      case 4:
        deviceDetailsController.systemConfigurePage.value = true;
        break;
      case 5:
        deviceDetailsController.graphPage.value = true;
        break;
      case 6:
        deviceDetailsController.errorsCodesRegistry.value = true;
        break;
      case 7:
        deviceDetailsController.errorsTimesRegistry.value = true;
        break;
      case 8:
        deviceDetailsController.errorsDatesRegistry.value = true;
        break;
    }
  }
}
