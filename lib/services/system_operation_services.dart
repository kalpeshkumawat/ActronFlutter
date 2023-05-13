import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/models/system_operations_model.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:get/get.dart';

class SystemOperationServices {
  static final SystemOperationServices _systemOperationServices =
      SystemOperationServices._internal();

  factory SystemOperationServices() {
    return _systemOperationServices;
  }

  SystemOperationServices._internal();
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');

  addSystemOperationValues(reg, val) {
    SystemOperationsModel sysOpsData =
        deviceDetailsController.systemOperationsData.value;
    if (reg == 8) {
      deviceDetailsController.sysOpsDataLoading.value = true;
      if (val & 1 << 8 == 256) {
        sysOpsData.controlMode = 'Wall control';
      } else if (val & 1 << 9 == 512) {
        sysOpsData.controlMode = 'Basic BMS';
      } else if (val & 1 << 8 == 256 && val & 1 << 9 == 512) {
        sysOpsData.controlMode = 'Wall Controll + BMS';
      } else if (val & 1 << 11 == 2048) {
        sysOpsData.controlMode = 'Advanced BMS';
      } else {
        sysOpsData.controlMode = '3rd Party Controle';
      }
    }
    if (reg == 12) {
      if (val & 0x0F == 0) {
        deviceDetailsController.operationMode.value = 'OFF';
        sysOpsData.operationMode = 'OFF';
      } else if (val & 0x0F == 1) {
        deviceDetailsController.operationMode.value = 'Cool';
        sysOpsData.operationMode = 'Cool';
      } else if (val & 0x0F == 2) {
        deviceDetailsController.operationMode.value = 'Heat';
        sysOpsData.operationMode = 'Heat';
      } else if (val & 0x0F == 3) {
        deviceDetailsController.operationMode.value = 'Fan';
        sysOpsData.operationMode = 'Fan';
      } else if (val & 0x0F == 4) {
        deviceDetailsController.operationMode.value = 'Auto';
        sysOpsData.operationMode = 'Auto';
      } else if (val & 0x0F == 5) {
        deviceDetailsController.operationModeFanMode.value = 0;
        sysOpsData.operationMode = 'Economiser';
      } else if (val & 0x0F == 6) {
        deviceDetailsController.operationModeFanMode.value = 1;
        sysOpsData.operationMode = 'Turbo';
      } else {
        deviceDetailsController.operationModeFanMode.value = 2;
        sysOpsData.operationMode = 'Quite';
      }
    }
    if (reg == 11) {
      sysOpsData.requestCompSpeed = '${val.toString()} %';
    }
    if (reg == 13) {
      sysOpsData.actualCompSpeed = '${val.toString()} %';
    }
    if (reg == 14) {
      deviceDetailsController.statusFlagsData.value = val.toString();
    }
    if (reg == 16) {
      sysOpsData.iduFanPercentage = '${val.toString()} %';
    }
    if (reg == 17) {
      sysOpsData.iduFanRpm = '${val.toString()} RPM';
    }
    if (reg == 18) {
      val > 3000
          ? sysOpsData.iduCoilTemp = '--'
          : sysOpsData.iduCoilTemp = '${(val / 10).toString()} \u2103';
    }
    if (reg == 20) {
      val > 3000
          ? sysOpsData.oduAmbientTemp = '--'
          : sysOpsData.oduAmbientTemp = '${(val / 10).toString()} \u2103';
    }
    if (reg == 21) {
      val > 3000
          ? sysOpsData.oduCoilTemp = '--'
          : sysOpsData.oduCoilTemp = '${(val / 10).toString()} \u2103';
    }
    if (reg == 24) {
      val > 3000
          ? sysOpsData.dischargeTemp = '--'
          : sysOpsData.dischargeTemp = '${(val / 10).toString()} \u2103';
    }
    if (reg == 25) {
      val > 3000
          ? sysOpsData.suctionTemp = '--'
          : sysOpsData.suctionTemp = '${(val / 10).toString()} \u2103';
    }
    if (reg == 93) {
      val > 3000
          ? sysOpsData.roomTemp = '--'
          : sysOpsData.roomTemp = '${(val / 10).toString()} \u2103';
    }
    if (reg == 26) {
      sysOpsData.hpPressure = '${(val / 10).toString()} kPa';
    }
    if (reg == 27) {
      sysOpsData.lpPressure = '${(val / 10).toString()} kPa';
    }
    if (reg == 32) {
      if (val & 1 << 0 == 0) {
        sysOpsData.oduFanSpeed = 'High';
      }
      if (val & 1 << 1 == 2) {
        sysOpsData.oduFanSpeed = 'Medium';
      }
      if (val & 1 << 2 == 4) {
        sysOpsData.oduFanSpeed = 'Low';
      }
      if (reg == 32) {
        if (val & 1 << 3 == 8) {
          sysOpsData.reverseValve = 'Heat';
        } else {
          sysOpsData.reverseValve = 'Cool';
        }
      }
      if (reg == 32) {
        if (val & 1 << 4 == 16) {
          sysOpsData.crankCaseHeater = 'On';
        } else {
          sysOpsData.crankCaseHeater = 'OFF';
        }
      }
      if (reg == 32) {
        if (val & 1 << 6 == 64) {
          sysOpsData.pfc = 'On';
        } else {
          sysOpsData.pfc = 'Off';
        }
      }
      if (reg == 32) {
        if (val & 1 << 7 == 128) {
          sysOpsData.fault = 'On';
        } else {
          sysOpsData.fault = 'On';
        }
      }
      if (reg == 32) {
        if (val & 1 << 8 == 256) {
          sysOpsData.compRun = 'On';
        } else {
          sysOpsData.compRun = 'Off';
        }
      }
    }
    if (reg == 34) {
      sysOpsData.exvTarget = val.toString();
    }
    if (reg == 35) {
      sysOpsData.exvPosition = val.toString();
    }
    if (reg == 36) {
      sysOpsData.oduState = val.toString();
    }
    if (reg == 37) {
      sysOpsData.oduStateTime = '${val.toString()} sec';
    }
    if (reg == 46) {
      sysOpsData.dischargeSuperheat = val.toString();
    }
    if (reg == 47) {
      sysOpsData.superheat = val.toString();
    }
    if (reg == 244) {
      sysOpsData.oduFanRpm = '${val.toString()} RPM';
    }
    deviceDetailsController.sysOpsDataLoading.value = false;
    deviceDetailsController.updateSystemOpsData(sysOpsData);
  }

  sendOperationModePackets({context}) async {
    var val;
    if (deviceDetailsController.operationModeSelectedValue.value == 0) {
      if (deviceDetailsController.operationModeFanMode.value == 0) {
        val = 33;
      } else if (deviceDetailsController.operationModeFanMode.value == 1) {
        val = 65;
      } else {
        val = 129;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 1) {
      if (deviceDetailsController.operationModeFanMode.value == 0) {
        val = 34;
      } else if (deviceDetailsController.operationModeFanMode.value == 1) {
        val = 66;
      } else {
        val = 130;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 2) {
      if (deviceDetailsController.operationModeFanMode.value == 0) {
        val = 36;
      } else if (deviceDetailsController.operationModeFanMode.value == 1) {
        val = 67;
      } else {
        val = 131;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 3) {
      if (deviceDetailsController.operationModeFanMode.value == 0) {
        val = 36;
      } else if (deviceDetailsController.operationModeFanMode.value == 1) {
        val = 68;
      } else {
        val = 132;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 4) {
      if (deviceDetailsController.operationModeFanMode.value == 0) {
        val = 48;
      } else if (deviceDetailsController.operationModeFanMode.value == 1) {
        val = 80;
      } else {
        val = 144;
      }
    }
    await PacketFrameService().createPacket(
        [1, 12, val], PacketFrameController().subopcodeWriteSingle);
  }
}
