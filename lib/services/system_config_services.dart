import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/controllers/system_configuration_controller.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:get/get.dart';

class SystemConfigServices {
  static final SystemConfigServices _systemConfigServices =
      SystemConfigServices._internal();

  factory SystemConfigServices() {
    return _systemConfigServices;
  }

  SystemConfigServices._internal();
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');

  addSystemConfigurationValues(reg, val) {
    if (reg == 8) {
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
      deviceDetailsController.economiserSettings.value.ecoMode = val.toString();
    }
    if (reg == 451) {
      deviceDetailsController.economiserSettings.value.ecoTempDiff =
          '${(val / 10).toString()} \u2103';
    }
    if (reg == 452) {
      deviceDetailsController.economiserSettings.value.ecoOutMinTemp =
          '${(val / 10).toString()} \u2103';
    }
    if (reg == 453) {
      deviceDetailsController.economiserSettings.value.ecoOutMaxTemp =
          '${(val / 10).toString()} \u2103';
    }
    if (reg == 454) {
      deviceDetailsController.economiserSettings.value.ecoOutMaxHum =
          '${(val / 10).toString()} %RH';
    }
    if (reg == 455) {
      deviceDetailsController.economiserSettings.value.ecoOutMaxMoist =
          '${(val / 10).toString()} g/Kg';
    }
    if (reg == 456) {
      deviceDetailsController.economiserSettings.value.ecoOutMaxDew =
          '${(val / 10).toString()} \u2103';
    }
    if (reg == 457) {
      deviceDetailsController.economiserSettings.value.ecoOutMaxEnthalpy =
          '${(val / 10).toString()} kJ/kg';
    }
    if (reg == 458) {
      deviceDetailsController.economiserSettings.value.ecoEnthalpy =
          '${(val / 10).toString()} kJ/kg';
    }
    if (reg == 459) {
      deviceDetailsController.economiserSettings.value.ecoCo2P1 =
          '${(val).toString()} ppm';
    }
    if (reg == 460) {
      deviceDetailsController.economiserSettings.value.ecoCo2P2 =
          '${(val).toString()} ppm';
    }
    if (reg == 461) {
      deviceDetailsController.economiserSettings.value.ecoCo2DamperP1 =
          '${(val).toString()} % Damper position';
    }
    if (reg == 462) {
      deviceDetailsController.economiserSettings.value.ecoCo2DamperP2 =
          '${(val).toString()} % Damper position';
    }
  }

  sendControlModePackets({context}) async {
    var val;
    if (systemConfigurationController.controlModeSelectedValue == 0) {
      val = 0;
    } else if (systemConfigurationController.controlModeSelectedValue == 1) {
      val = 256;
    } else if (systemConfigurationController.controlModeSelectedValue == 2) {
      val = 512;
    } else if (systemConfigurationController.controlModeSelectedValue == 3) {
      val = 768;
    } else if (systemConfigurationController.controlModeSelectedValue == 4) {
      val = 2048;
    }
    await PacketFrameService().createPacket([
      1,
      8,
      val,
    ], PacketFrameController().subopcodeWriteSingle);
  }
}
