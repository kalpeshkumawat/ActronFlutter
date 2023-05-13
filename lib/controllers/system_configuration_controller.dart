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
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
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
                leading: CommonWidgets().text(
                  text: list[index],
                  size: 14.0,
                  fontWeight: FontWeight.w500,
                  textColor: Colors.black,
                  fontFamily: 'Karbon',
                ),
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
        CommonWidgets().text(
          text: 'Indoor Settings',
          size: heading,
          fontWeight: FontWeight.w600,
          textColor: Colors.black,
          fontFamily: 'Karbon',
        ),
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
        CommonWidgets().text(
          text: 'Warranty Registration',
          size: heading,
          fontWeight: FontWeight.w600,
          textColor: Colors.black,
          fontFamily: 'Karbon',
        ),
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
              sendEmail(
                  emailType: 'Registration',
                  body:
                      '''
          This e-mail contains the system information for ${deviceDetailsController.model}: ${deviceDetailsController.serial}   
          Registered by ${installer.value.text}
          Location is ${bleController.currentAddress.value}
          ''',
                  recipient: 'actronLink@actronair.com');
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

  sendEmail({emailType, body, recipient}) async {
    var file = await ImportExportService().readFile();
    debugPrint('file is $file');
    final Email email = Email(
      body: body,
      subject:
          '${deviceDetailsController.model}: ${deviceDetailsController.serial} $emailType $date',
      recipients: [recipient],
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
        itemCount: deviceDetailsController.economiserLeading.length,
        itemBuilder: (contex, i) {
          var values = deviceDetailsController.economiserSettings.value
              .toJson()
              .values
              .toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonWidgets().text(
                  text: deviceDetailsController.economiserLeading[i].leading,
                  size: 16.0,
                  fontWeight: FontWeight.w400,
                  textColor: Colors.black,
                  fontFamily: 'Karbon',
                ),
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
                            label: deviceDetailsController
                                .economiserLeading[i].leading,
                            placeholder: deviceDetailsController
                                .economiserLeading[i].leading,
                            type: TextInputType.number,
                            register: deviceDetailsController
                                .economiserLeading[i].reg,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10.0),
                    CommonWidgets().text(
                      text: values[i] ?? '--',
                      size: 16.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.black,
                      fontFamily: 'Karbon',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
