import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/home_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/models/system_config_model.dart';
import 'package:airlink/services/device_details_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/ble_controller.dart';
import '../../controllers/device_details_controller.dart';
import '../../controllers/system_configuration_controller.dart';
import '../../services/ble_service.dart';

class SystemConfiguration extends StatefulWidget {
  const SystemConfiguration({Key? key}) : super(key: key);

  @override
  State<SystemConfiguration> createState() => _SystemConfigurationState();
}

class _SystemConfigurationState extends State<SystemConfiguration> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final homeController = Get.find<HomeController>(tag: 'homeController');
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    DeviceDetailsService().managingPages(pageNumber: 4);
    if (bleController.connectedDevice != null) {
      BleService().sendPackets(150, PacketFrameController().sysConfig);
    } else {
      getSysConfigData();
    }
    super.initState();
  }

  @override
  void dispose() {
    deviceDetailsController.systemConfigurePage.value = false;
    systemConfigurationController.installer.value.text = '';
    super.dispose();
  }

  getSysConfigData() {
    for (SystemConfigModel element in homeController.deviceSystemConfigData) {
      systemConfigurationController.lowPwm.value.text =
          element.lowPwm.toString();
      systemConfigurationController.medPwm.value.text =
          element.medPwm.toString();
      systemConfigurationController.highPwm.value.text =
          element.highPwm.toString();
      systemConfigurationController.lowRpm.value.text =
          element.lowRpm.toString();
      systemConfigurationController.medRpm.value.text =
          element.medRpm.toString();
      systemConfigurationController.highRpm.value.text =
          element.highRpm.toString();
      systemConfigurationController.fanFilter.value.text =
          element.fanFilterCountdown.toString();
      systemConfigurationController.controlModeSelectedValue = int.parse(
        element.controlMode.toString(),
      );
      deviceDetailsController.updateEconomiserSettings(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'System Configuration',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              deviceDetailsController.systemConfigurePage.value = false;
              systemConfigurationController.installer.value.text = '';
              Get.back();
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: itemData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: index % 2 == 0
                          ? const Color.fromRGBO(243, 243, 243, 1)
                          : const Color.fromRGBO(250, 250, 250, 1),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          cardColor: index % 2 == 0
                              ? const Color.fromRGBO(243, 243, 243, 1)
                              : const Color.fromRGBO(250, 250, 250, 1),
                        ),
                        child: ExpansionPanelList(
                          animationDuration: const Duration(milliseconds: 500),
                          expandedHeaderPadding:
                              const EdgeInsets.only(bottom: 0.0),
                          dividerColor: Colors.black,
                          elevation: 1,
                          children: [
                            ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        itemData[index].headerItem,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => systemConfigurationController
                                              .controlDataEntered[index]
                                          ? const Icon(
                                              Icons.check,
                                              color: Color.fromRGBO(
                                                  78, 203, 113, 1),
                                            )
                                          : const Icon(
                                              Icons.priority_high,
                                              color: Color.fromRGBO(
                                                  255, 199, 0, 1),
                                            ),
                                    )
                                  ],
                                );
                              },
                              body: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 20),
                                child: itemData[index].headerItem ==
                                        'Control Mode'
                                    ? systemConfigurationController.controlMode(
                                        list: [
                                          '3rd Party',
                                          'Wall Control',
                                          'BMS',
                                          'Wall Controll + BMS',
                                          'Advanced BMS'
                                        ],
                                        state: () => settingState(),
                                      )
                                    : itemData[index].headerItem ==
                                            'Operation Settings'
                                        ? systemConfigurationController
                                            .operationSettings(
                                                // () => changeFanFilter(),
                                                )
                                        : itemData[index].headerItem ==
                                                'Economiser Settings'
                                            ? systemConfigurationController
                                                .economiserSettings(context)
                                            : systemConfigurationController
                                                .information(),
                              ),
                              isExpanded: itemData[index].expanded,
                              canTapOnHeader: true,
                            )
                          ],
                          expansionCallback: (int item, bool status) {
                            setState(
                              () {
                                var previousElement = itemData[index].expanded;
                                previousElement == true
                                    ? previousElement = false
                                    : null;
                                itemData[index].expanded =
                                    !itemData[index].expanded;
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // mail box
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.17,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      systemConfigurationController.sendEmail(
                          emailType: 'Registration',
                          body: '''
          This e-mail contains the system information for ${deviceDetailsController.model}: ${deviceDetailsController.serial}
          
          Registered by ${systemConfigurationController.installer.value.text}
          Location is ${bleController.currentAddress.value}
          ''',
                          recipient: 'warranty@actronair.com.au');
                    },
                    icon: const Icon(
                      Icons.mail,
                      size: 20.0,
                    ),
                    label: CommonWidgets().text(
                      text: 'Warranty Registration',
                      size: 16.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                      fontFamily: 'Karbon',
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
      headerItem: 'Control Mode',
    ),
    ItemModel(
      headerItem: 'Operation Settings',
    ),
    ItemModel(
      headerItem: 'Economiser Settings',
    ),
    ItemModel(
      headerItem: 'Information',
    ),
  ];

  settingState() {
    setState(() {});
  }
}

class ItemModel {
  bool expanded;
  String headerItem;

  ItemModel({
    this.expanded = false,
    required this.headerItem,
  });
}
