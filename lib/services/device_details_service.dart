import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/search_list_controller.dart';
import 'package:airlink/controllers/system_configuration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/sysops_data_model.dart';

class DeviceDetailsService {
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');
  final searchListController =
      Get.put(SearchListController(), tag: 'searchListController');

  checkingPresentPage(reg, val, event) {
    if (deviceDetailsController.deviceDetailsPage.value) {
      addDeviceDetailsData(reg, val);
    }
    if (deviceDetailsController.operationsTillHpPressure.value) {
      addValuesTillHpPressure(reg, val);
    }
    if (deviceDetailsController.operationsTillVsdMotor.value) {
      addValuesTillVdsMotor(reg, val);
    }
    if (deviceDetailsController.errorsCodesRegistry.value) {
      addErrors(reg, val, deviceDetailsController.errorCodes);
    }
    if (deviceDetailsController.errorsDatesRegistry.value) {
      addErrors(reg, val, deviceDetailsController.errorDates);
    }
    if (deviceDetailsController.errorsTimesRegistry.value) {
      addErrors(reg, val, deviceDetailsController.errorTimes);
    }
    if (deviceDetailsController.activeErrorsRegistry.value) {
      deviceDetailsController.activeError.value = "E ${val.toString()}";
    }
    if (deviceDetailsController.graphPage.value) {
      addGraphsData(reg, val);
    }
    if (deviceDetailsController.economiserSettingPage.value) {
      addSysConfig(reg, val);
    }
    if (deviceDetailsController.advancedSearchPage.value) {
      advancedSearch(reg, val, event);
    }
  }

  addErrors(reg, val, controller) {
    controller.add("1 $val");
  }

  addGraphsData(reg, val) {
    if (reg == 13) {
      deviceDetailsController.compSpeedGraphData.add(
        val.toDouble(),
      );
    }
    if (reg == 21) {
      deviceDetailsController.coilTempGraphData.add(val.toDouble());
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

  addDeviceDetailsData(reg, val) {
    // please do add indoor serail and model packetes in packet controller and the receving funtionality here.
    if (reg == 1013 ||
        reg == 1014 ||
        reg == 1015 ||
        reg == 1016 ||
        reg == 1017 ||
        reg == 1018 ||
        reg == 1019) {
      for (var element in searchListController.searchList) {
        if (element.name == 'ODU Model') {
          element.value = val.toString();
        }
      }
      if (reg == 1013) {
        deviceDetailsController.model.value = '';
      }
      deviceDetailsController.model.value += decimalToText(val);
    } else if (reg == 1010 || reg == 1011 || reg == 1012) {
      for (var element in searchListController.searchList) {
        if (element.name == 'ODU Serial') {
          element.value = val.toString();
        }
      }
      if (reg == 1010) {
        deviceDetailsController.serial.value = '';
      }
      deviceDetailsController.serial.value += decimalToText(val);
    } else if (reg == 4) {
      deviceDetailsController.oduVersion.value = hexToDecimalIduOdu(val);
    } else if (reg == 115) {
      deviceDetailsController.iduVersion.value = hexToDecimalIduOdu(val);
    }
  }

  String hexToDecimalIduOdu(val) {
    String temp = val.toRadixString(16);
    var byte1 = (int.parse(temp, radix: 16) >> 8) & 0xff;
    var byte2 = int.parse(temp, radix: 16) & 0xff;
    var finalDecimal = "$byte1.$byte2";
    return finalDecimal;
  }

  String decimalToText(val) {
    return List.generate(
      val.toRadixString(16).length ~/ 2,
          (i) => String.fromCharCode(
          int.parse(val.toRadixString(16).substring(i * 2, (i * 2) + 2), radix: 16)),
    ).join();
  }

  addValuesTillHpPressure(reg, val) {
    if (reg == 8) {
      deviceDetailsController.sysOpsDataLoading.value = false;
      debugPrint('bit value is ${val & 1 << 8}');
      if (val & 1 << 8 == 256) {
        debugPrint('in bit 8');
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Control Mode', trailing: 'Wall Control'),
        );
      } else if (val & 1 << 9 == 512) {
        debugPrint('in bit 9');
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Control Mode', trailing: 'Basic BMS'),
        );
      } else if (val & 1 << 8 == 256 && val & 1 << 9 == 512) {
        debugPrint('in bit 8, 9');
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Control Mode', trailing: 'Wall Controll + BMS'),
        );
      } else if (val & 1 << 11 == 2048) {
        debugPrint('in bit 11');
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Control Mode', trailing: 'Advanced BMS'),
        );
      } else {
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Control Mode', trailing: '3rd Party Controls'),
        );
      }
    }
    if (reg == 12) {
      if (val & 0x0F == 0) {
        deviceDetailsController.operationModeSelectedValue.value = 0;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'OFF'),
        );
        deviceDetailsController.operationMode.value = 'Off';
      } else if (val & 0x0F == 1) {
        deviceDetailsController.operationModeSelectedValue.value = 1;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'Cool'),
        );
        deviceDetailsController.operationMode.value = 'Cool';
      } else if (val & 0x0F == 2) {
        deviceDetailsController.operationModeSelectedValue.value = 2;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'Heat'),
        );
        deviceDetailsController.operationMode.value = 'Heat';
      } else if (val & 0x0F == 3) {
        deviceDetailsController.operationModeSelectedValue.value = 3;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'Fan'),
        );
        deviceDetailsController.operationMode.value = 'Fan';
      } else if (val & 0x0F == 4) {
        deviceDetailsController.operationModeSelectedValue.value = 4;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'Auto'),
        );
        deviceDetailsController.operationMode.value = 'Auto';
      } else if (val & 0x0F == 5) {
        deviceDetailsController.selectMode.value = 0;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'Economiser'),
        );
      } else if (val & 0x0F == 6) {
        deviceDetailsController.selectMode.value = 1;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'Turbo'),
        );
      } else {
        deviceDetailsController.selectMode.value = 2;
        deviceDetailsController.updateSystemOperationsModesAndSpeeds(
          SystemOperationRegisterModels(
              leading: 'Operation Mode', trailing: 'Quite'),
        );
      }
    }
    if (reg == 11) {
      deviceDetailsController.updateSystemOperationsModesAndSpeeds(
        SystemOperationRegisterModels(
            leading: 'Request Compressor Speed',
            trailing: '${val.toString()} %'),
      );
    }
    if (reg == 13) {
      deviceDetailsController.updateSystemOperationsModesAndSpeeds(
        SystemOperationRegisterModels(
            leading: 'Actual Compressor Speed',
            trailing: '${val.toString()} %'),
      );
    }
    if (reg == 14) {
      deviceDetailsController.statusFlagsData.value = val.toString();
    }
    if (reg == 16) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'IDU Fan Percentage', trailing: '${val.toString()} %'),
      );
    }
    if (reg == 17) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'IDU Fan RPM', trailing: '${val.toString()} RPM'),
      );
    }
    if (reg == 18) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'IDU Coil Temperature',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 20) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'ODU Ambient Temperature',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 21) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'ODU Coil Temperature',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 24) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Discharge Temperature',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 25) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Suction Temperature',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
  }

  addValuesTillVdsMotor(reg, val) {
    if (reg == 93) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Room Temperature',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 26) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'HP Pressure', trailing: '${val.toString()} KPa'),
      );
    }
    if (reg == 27) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'LP Pressure', trailing: '${val.toString()} KPa'),
      );
    }
    if (reg == 32) {
      if (val & 1 << 0 == 1) {
        deviceDetailsController.updateSystemOperationsData(
          SystemOperationRegisterModels(
              leading: 'ODU Fan Speed(V/RPM/Relay)', trailing: 'High'),
        );
      }
      if (val & 1 << 1 == 2) {
        deviceDetailsController.updateSystemOperationsData(
          SystemOperationRegisterModels(
              leading: 'ODU Fan Speed(V/RPM/Relay)', trailing: 'Medium'),
        );
      }
      if (val & 1 << 2 == 4) {
        deviceDetailsController.updateSystemOperationsData(
          SystemOperationRegisterModels(
              leading: 'ODU Fan Speed(V/RPM/Relay)', trailing: 'Low'),
        );
      }
      if (reg == 32) {
        if (val & 1 << 3 == 8) {
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Reverse Valve',
              trailing: 'Heat',
            ),
          );
        } else {
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Reverse Valve',
              trailing: 'Cool',
            ),
          );
        }
      }
      if (reg == 32) {
        if (val & 1 << 4 == 16) {
          deviceDetailsController.searchList
              .add({'leading': 'Crank Case Heater', 'trailing': 'On'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Crank Case Heater',
              trailing: 'On',
            ),
          );
        } else {
          deviceDetailsController.searchList
              .add({'leading': 'Crank Case Heater', 'trailing': 'Off'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Crank Case Heater',
              trailing: 'Off',
            ),
          );
        }
      }
      if (reg == 32) {
        if (val & 1 << 6 == 64) {
          deviceDetailsController.searchList
              .add({'leading': 'PFC', 'trailing': 'On'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'PFC',
              trailing: 'On',
            ),
          );
        } else {
          deviceDetailsController.searchList
              .add({'leading': 'PFC', 'trailing': 'Off'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'PFC',
              trailing: 'Off',
            ),
          );
        }
      }
      if (reg == 32) {
        if (val & 1 << 7 == 128) {
          deviceDetailsController.searchList
              .add({'leading': 'Fault', 'trailing': 'On'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Fault',
              trailing: 'On',
            ),
          );
        } else {
          deviceDetailsController.searchList
              .add({'leading': 'Fault', 'trailing': 'Off'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Fault',
              trailing: 'Off',
            ),
          );
        }
      }
      if (reg == 32) {
        if (val & 1 << 8 == 256) {
          deviceDetailsController.searchList
              .add({'leading': 'Comp RUn', 'trailing': 'On'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Comp Run',
              trailing: 'On',
            ),
          );
        } else {
          deviceDetailsController.searchList
              .add({'leading': 'Comp Run', 'trailing': 'Off'});
          deviceDetailsController.updateSystemOperationsData(
            SystemOperationRegisterModels(
              leading: 'Comp Run',
              trailing: 'Off',
            ),
          );
        }
      }
    }
    if (reg == 34) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'EXV Target', trailing: val.toString()),
      );
    }
    if (reg == 35) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'EXV Position', trailing: val.toString()),
      );
    }
    if (reg == 36) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'ODU State', trailing: val.toString()),
      );
    }
    if (reg == 37) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'ODU State Time', trailing: val.toString()),
      );
    }
    if (reg == 46) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Discharge Superheat', trailing: val.toString()),
      );
    }
    if (reg == 47) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Superheat', trailing: val.toString()),
      );
    }
    if (reg == 244) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'ODU Fan RPM', trailing: '${val.toString()} RPM'),
      );
    }
  }

  addSysConfig(reg, val) {
    if (reg == 8) {
      debugPrint(
          'value of checkbox before is ${systemConfigurationController.controlModeSelectedValue.toString()}');
      debugPrint('check types ${val.runtimeType == 256.runtimeType}');
      if (val & 1 << 8 == 256) {
        systemConfigurationController.controlModeSelectedValue = 1;
      } else if (val & 1 << 9 == 512) {
        systemConfigurationController.controlModeSelectedValue = 2;
      } else if (val & 1 << 8 == 256 && val & 1 << 9 == 512) {
        systemConfigurationController.controlModeSelectedValue = 3;
      } else if (val & 1 << 11 == 2048) {
        systemConfigurationController.controlModeSelectedValue = 4;
      } else {
        systemConfigurationController.controlModeSelectedValue = 0;
      }
      systemConfigurationController.controlDataEntered[0] = true;
    }
    if (reg == 100) {
      debugPrint('val is 100 $val');
      systemConfigurationController.lowPwm.value.text = val.toString();
    }
    if (reg == 101) {
      systemConfigurationController.medPwm.value.text = val.toString();
    }
    if (reg == 102) {
      systemConfigurationController.highPwm.value.text = val.toString();
    }
    if (reg == 103) {
      systemConfigurationController.lowRpm.value.text = val.toString();
    }
    if (reg == 104) {
      systemConfigurationController.medRpm.value.text = val.toString();
    }
    if (reg == 105) {
      systemConfigurationController.highRpm.value.text = val.toString();
    }
    if (reg == 108) {
      systemConfigurationController.fanFilter.value.text = val.toString();
      systemConfigurationController.controlDataEntered[1] = true;
    }
    if (reg == 450) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Mode', trailing: val.toString()),
      );
    }
    if (reg == 451) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Temperature Difference',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 452) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Outside Min Temp',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 453) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Outside Max Temp',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 454) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Outside Max Humidity',
            trailing: '${(val).toString()} %RH'),
      );
    }
    if (reg == 455) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Outside Max Moisture',
            trailing: '${(val / 10).toString()} g/Kg '),
      );
    }
    if (reg == 456) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Outside Max Dew Point',
            trailing: '${(val / 10).toString()} \u2103'),
      );
    }
    if (reg == 457) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Outside Max Enthalpy',
            trailing: '${(val / 10).toString()} kJ/kg'),
      );
    }
    if (reg == 458) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Enthalpy Delta',
            trailing: '${(val / 10).toString()} kJ/kg'),
      );
    }
    if (reg == 459) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Co2 P1', trailing: '${(val).toString()} ppm'),
      );
    }
    if (reg == 460) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Co2 P2', trailing: '${(val).toString()} ppm'),
      );
    }
    if (reg == 461) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Co2 Damper P1',
            trailing: '${(val).toString()} % Damper position'),
      );
    }
    if (reg == 462) {
      deviceDetailsController.updateSystemOperationsData(
        SystemOperationRegisterModels(
            leading: 'Economiser Co2 Damper P2',
            trailing: '${(val).toString()} % Damper position'),
      );
    }
  }

  advancedSearch(reg, val, event) {
    var searchData = searchListController.searchResult.toList();
    for (var element in searchData) {
      if (reg == element.startIndex) {
        if (element.name.contains('Temp') ||
            element.name.contains('Superheat')) {
          element.value = '${(val / 10).toString()} \u2103';
        } else if (element.name.contains('Pressure')) {
          element.value = '${val.toString()} kPa';
        } else if (element.name.contains('10V')) {
          element.value = '${(val / 10).toString()} V';
        } else if (element.name.contains('Speed')) {
          element.value = '${val.toString()} %';
        } else if (element.name.contains('RPM')) {
          element.value = '${val.toString()} RPM';
        } else if (element.name.contains('Humidity')) {
          element.value = '${val.toString()} % RH';
        } else if (element.name.contains('Damper')) {
          element.value = '${val.toString()} %';
        } else if (element.name.contains('Moisture')) {
          element.value = '${(val / 10).toString()} g/Kg';
        } else if (element.name.contains('Enthalpy')) {
          element.value = '${(val / 10).toString()} kj/Kg';
        } else if (element.name.contains('Thereshold')) {
          element.value = '${val.toString()} ppm';
        } else if (element.name.contains('Time')) {
          element.value = '${val.toString()} sec';
        } else {
          element.value = val.toString();
        }
      }
    }
    searchListController.searchResult.assignAll(searchData);
  }
}
