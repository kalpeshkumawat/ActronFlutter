import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/controllers/search_list_controller.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:get/get.dart';

class AdvancedSearchService {
  final searchListController =
      Get.find<SearchListController>(tag: 'searchListController');

  // send single register using gesture detector
  sendSearchRegisters({reg, length}) async {
    List register = [];
    if (length > 0) {
      for (var i = 0; i < length; i++) {
        register.add(reg);
        reg = reg + 1;
      }
    } else {
      register.add(reg);
    }
    await PacketFrameService()
        .createPacket(register, PacketFrameController().subopcodeRead);
  }
}
