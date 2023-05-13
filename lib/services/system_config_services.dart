import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/controllers/system_configuration_controller.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:get/get.dart';

class SystemConfigServices {
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');

  sendControlModePackets({context}) async {
    var val;
    if (systemConfigurationController.controlModeSelectedValue == 0) {
      val = 9459;
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
