import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/ble_controller.dart';
import '../../controllers/device_details_controller.dart';
import '../../controllers/system_configuration_controller.dart';
import '../../services/ble_service.dart';
import '../../services/import_export_service.dart';

class SystemConfiguration extends StatefulWidget {
  const SystemConfiguration({Key? key}) : super(key: key);

  @override
  State<SystemConfiguration> createState() => _SystemConfigurationState();
}

class _SystemConfigurationState extends State<SystemConfiguration> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  final systemConfigurationController = Get.find<SystemConfigurationController>(
      tag: 'systemConfigurationController');
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    deviceDetailsController.economiserSettingPage.value = true;
    deviceDetailsController.deviceDetailsPage.value = false;
    deviceDetailsController.operationsTillHpPressure.value = false;
    deviceDetailsController.operationsTillVsdMotor.value = false;
    deviceDetailsController.errorsCodesRegistry.value = false;
    deviceDetailsController.errorsDatesRegistry.value = false;
    deviceDetailsController.errorsTimesRegistry.value = false;
    deviceDetailsController.graphPage.value = false;
    deviceDetailsController.advancedSearchPage.value = false;
    if (bleController.connectedDevice != null) {
      BleService().sendPackets(150, PacketFrameController().sysConfig);
    }
    super.initState();
  }

  @override
  void dispose() {
    deviceDetailsController.economiserSettingPage.value = false;
    systemConfigurationController.installer.value.text = '';
    super.dispose();
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
              deviceDetailsController.economiserSettingPage.value = false;
              systemConfigurationController.installer.value.text = '';
              Get.back();
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
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
            Column(
              children: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    )),
                    onPressed: () {
                      sendEmail('Registration', '''
          This e-mail contains the system information for ${deviceDetailsController.model}: ${deviceDetailsController.serial}
          
          Registered by ${systemConfigurationController.installer.value.text}
          Location is ${bleController.currentAddress.value}
          ''');
                    },
                    icon: const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Icon(
                        Icons.mail,
                        size: 20.0,
                      ),
                    ),
                    label: CommonWidgets().text(
                        'Warranty Registration',
                        16.0,
                        FontWeight.w600,
                        TextAlign.center,
                        Colors.white,
                        'Karbon')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendEmail(emailType, body) async {
    var date = DateFormat.yMMMMd('en_US').format(DateTime.now());
    var file = await ImportExportService().readFile();
    // systemConfigurationController.currentAddress =
    //     await systemConfigurationController.getAddressFromLatLng();
    debugPrint('file is $file');
    final Email email = Email(
      body: body,
      subject:
          '${deviceDetailsController.model}: ${deviceDetailsController.serial} $emailType $date',
      recipients: ['warranty@actronair.com.au'],
      attachmentPaths: [file],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
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
