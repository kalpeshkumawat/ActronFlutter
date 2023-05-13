import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SystemOperationServices {
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');

  sendOperationModePackets({context}) async {
    // need to set two bits of a value to send it to the device
    // if(deviceDetailsController.selectMode){}
    var val;
    if (deviceDetailsController.operationModeSelectedValue.value == 0) {
      if (deviceDetailsController.selectMode.value == 0) {
        val = 33;
      } else if (deviceDetailsController.selectMode.value == 1) {
        val = 65;
      } else {
        val = 129;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 1) {
      if (deviceDetailsController.selectMode.value == 0) {
        val = 34;
      } else if (deviceDetailsController.selectMode.value == 1) {
        val = 66;
      } else {
        val = 130;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 2) {
      if (deviceDetailsController.selectMode.value == 0) {
        val = 36;
      } else if (deviceDetailsController.selectMode.value == 1) {
        val = 67;
      } else {
        val = 131;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 3) {
      if (deviceDetailsController.selectMode.value == 0) {
        val = 36;
      } else if (deviceDetailsController.selectMode.value == 1) {
        val = 68;
      } else {
        val = 132;
      }
    } else if (deviceDetailsController.operationModeSelectedValue.value == 4) {
      if (deviceDetailsController.selectMode.value == 0) {
        val = 48;
      } else if (deviceDetailsController.selectMode.value == 1) {
        val = 80;
      } else {
        val = 144;
      }
    }
    await PacketFrameService().createPacket(
        [1, 12, val], PacketFrameController().subopcodeWriteSingle);
  }
}
