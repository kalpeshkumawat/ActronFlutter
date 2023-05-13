import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/services/import_export_service.dart';
import 'package:airlink/services/system_config_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'device_details_controller.dart';

class SystemConfigurationController extends GetxController {
  final deviceDetailsController =
      Get.put(DeviceDetailsController(), tag: 'deviceDetailsController');
  bool isBasicBmsChecked = false;
  bool isWallBmsChecked = false;
  bool isAdvancedBmsChecked = false;
  final bleController = Get.find<BleController>(tag: 'bleController');
  final lowPwm = TextEditingController().obs;
  final medPwm = TextEditingController().obs;
  final highPwm = TextEditingController().obs;
  final lowRpm = TextEditingController().obs;
  final medRpm = TextEditingController().obs;
  final highRpm = TextEditingController().obs;
  final installer = TextEditingController().obs;
  final fanFilter = TextEditingController().obs;
  String dropdownValue = 'Option 1';
  TextEditingController economiserData = TextEditingController();
  List<bool> controlDataEntered = [false, false, false, true].obs;
  double heading = 20.0;
  double subHeading = 16.0;
  double body = 14.0;
  int controlModeSelectedValue = -1;

  Widget controlMode({list, state}) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: Get.height * .4,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CommonWidgets().text(list[index], 14.0,
                    FontWeight.w500, TextAlign.start, Colors.black, 'Karbon'),
                trailing: Checkbox(
                  shape: const CircleBorder(),
                  value: controlModeSelectedValue == index,
                  onChanged: (_) async {
                    controlModeSelectedValue = index;
                    await SystemConfigServices()
                        .sendControlModePackets(context: context);
                    state();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget operationSettings() {
    return Column(
      children: [
        CommonWidgets().text('Indoor Settings', heading, FontWeight.w600,
            TextAlign.start, Colors.black, 'Karbon'),
        const SizedBox(
          height: 15.0,
        ),
        CommonWidgets().systemComnfigurationRowInput(list: [
          {'label': 'Low PWM', 'value': lowPwm, 'function': () => {}},
          {'label': 'Med PWM', 'value': medPwm, 'function': () => {}},
          {'label': 'High PWM', 'value': highPwm, 'function': () => {}},
          {'label': 'Low RPM', 'value': lowRpm, 'function': () => {}},
          {'label': 'Med RPM', 'value': medRpm, 'function': () => {}},
          {'label': 'High RPM', 'value': highRpm, 'function': () => {}},
          {
            'label': ' Fan Filter Hours Countdown',
            'value': fanFilter,
            'function': () {}
          },
        ], sizedBoxHeight: 270.0),
      ],
    );
  }

  var date = DateFormat.yMMMMd('en_US').format(DateTime.now());

  Widget information() {
    return Column(
      children: [
        CommonWidgets().systemConfigOperationSetting(list: [
          {
            'label': 'Model Number',
            'value': deviceDetailsController.model.value
          },
          {
            'label': 'Serial Number',
            'value': deviceDetailsController.serial.value
          },
          {
            'label': 'Outdoor Software',
            'value': deviceDetailsController.oduVersion.value
          },
          {
            'label': 'Indoor Software',
            'value': deviceDetailsController.iduVersion.value
          },
        ], sizedBoxHeight: 160.0),
        CommonWidgets().text('Warranty Registration', heading, FontWeight.w600,
            TextAlign.start, Colors.black, 'Karbon'),
        const SizedBox(
          height: 15.0,
        ),
        CommonWidgets().systemComnfigurationRowInput(list: [
          {'label': 'Installer', 'value': installer},
        ], sizedBoxHeight: 30.0),
        CommonWidgets().systemConfigOperationSetting(list: [
          {'label': 'Date', 'value': date},
          {
            'label': 'Model Number',
            'value': deviceDetailsController.model.value
          },
          {
            'label': 'Serial Number',
            'value': deviceDetailsController.serial.value
          },
        ], sizedBoxHeight: 160.0),
        ElevatedButton(
          onPressed: () {
            if (installer.value.text != '') {
              sendEmail('Registration', '''
          This e-mail contains the system information for ${deviceDetailsController.model}: ${deviceDetailsController.serial}   
          Registered by ${installer.value.text}
          Location is ${bleController.currentAddress.value}
          ''');
            } else {
              CommonWidgets().errorSnackbar(
                  title: '', message: 'Installer name can\'t be empty');
            }
          },
          style: ElevatedButton.styleFrom(
            primary: (const Color(0xff4da6de)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
            minimumSize: const Size(120.0, 32.0),
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  sendEmail(emailType, body) async {
    var file = await ImportExportService().readFile();
    // SharedPreferences prefs = getSharedPreferences("");
    debugPrint('file is $file');
    final Email email = Email(
      body: body,
      subject:
          '${deviceDetailsController.model}: ${deviceDetailsController.serial} $emailType $date',
      recipients: ['actronLink@actronair.com'],
      attachmentPaths: [file],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  Widget economiserSettings(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: deviceDetailsController.economiserSettings.length,
        itemBuilder: (contex, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonWidgets().text(
                    deviceDetailsController.economiserSettings[i].leading,
                    17.0,
                    FontWeight.w400,
                    TextAlign.start,
                    Colors.black,
                    'Karbon'),
                Row(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                        size: 14.0,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CommonWidgets().registerEditDialog(
                            context: context,
                            data: economiserData,
                            label:
                                'please enter ${deviceDetailsController.economiserSettings[i].leading}',
                            placeholder: deviceDetailsController
                                .economiserSettings[i].leading,
                            type: const TextInputType.numberWithOptions(decimal: true, signed: false),
                            register: deviceDetailsController
                                .economiserSettings[i].reg,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10.0),
                    CommonWidgets().text(
                        deviceDetailsController.economiserSettings[i].trailing,
                        14.0,
                        FontWeight.w400,
                        TextAlign.start,
                        Colors.black,
                        'Karbon'),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
