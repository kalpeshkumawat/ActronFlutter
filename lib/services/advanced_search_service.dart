import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/controllers/search_list_controller.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:get/get.dart';

class AdvancedSearchService {
  static final AdvancedSearchService _advancedSearchService =
      AdvancedSearchService._internal();

  factory AdvancedSearchService() {
    return _advancedSearchService;
  }

  AdvancedSearchService._internal();
  final searchListController =
      Get.find<SearchListController>(tag: 'searchListController');

  addAdvanceSearchValues(reg, val, event) {
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
