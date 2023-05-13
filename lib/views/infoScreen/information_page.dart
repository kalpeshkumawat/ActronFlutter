import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/views/devices.dart';
import 'package:airlink/views/infoScreen/terms_&_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../services/import_export_service.dart';

class Information extends StatefulWidget {
  const Information({Key? key}) : super(key: key);

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final bleController = Get.find<BleController>(tag: 'bleController');
  List contactInfo = [
    {
      'icon': 'assets/call.png',
      'text': '1800 199 229',
      'url': 'tel:1800 199 229',
    },
    {
      'icon': 'assets/mail.png',
      'text': 'service@actronair.com.au',
      'url':
          'mailto:service@actronair.com.au?subject=App Feedback&body=App Version 3.23',
    },
    {
      'icon': 'assets/mail.png',
      'text': 'technicalsupport@actronair.com.au',
      'url':
          'mailto:technicalsupport@actronair.com.au?subject=App Feedback&body=App Version 3.23',
    }
  ];

  @override
  void initState() {
    getPackageInfo();
    super.initState();
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    bleController.appVersion.value = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'Information',
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => {
              Get.to(
                () => const Devices(),
              ),
            },
          ),
        ),
        body: Column(
          children: [
            GestureDetector(
              child: Container(
                height: 64.0,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(243, 243, 243, 1),
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWidgets().text(
                        'Terms & Condition',
                        16.0,
                        FontWeight.w600,
                        TextAlign.center,
                        const Color.fromRGBO(88, 89, 91, 1),
                        'Karbon'),
                    Icon(
                      Icons.navigate_next,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              onTap: () => {
                Get.to(
                  () => const TermsAndConditions(),
                )
              },
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonWidgets().text(
                          'Software Version',
                          14.0,
                          FontWeight.w600,
                          TextAlign.start,
                          const Color.fromRGBO(188, 190, 192, 1),
                          'Karbon'),
                      Obx(
                        () => CommonWidgets().text(
                            bleController.appVersion.value.toString(),
                            14.0,
                            FontWeight.w600,
                            TextAlign.start,
                            const Color.fromRGBO(65, 64, 66, 1),
                            'Karbon'),
                      ),
                    ],
                  ),
                ),
                bleController.savedDevices.isNotEmpty
                    ? SizedBox(
                        height: 50.0,
                        child: ListView.builder(
                          itemCount: bleController.savedDevices.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonWidgets().text(
                                      bleController.savedDevices[i]['name'],
                                      14.0,
                                      FontWeight.w600,
                                      TextAlign.start,
                                      const Color.fromRGBO(188, 190, 192, 1),
                                      'Karbon'),
                                  CommonWidgets().text(
                                      bleController.savedDevices[i]['version'],
                                      14.0,
                                      FontWeight.w600,
                                      TextAlign.start,
                                      const Color.fromRGBO(65, 64, 66, 1),
                                      'Karbon'),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
                const Divider(
                  color: Color.fromRGBO(
                    193,
                    193,
                    193,
                    1,
                  ),
                  thickness: 2.0,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Image.asset(
                  'assets/logo-color.png',
                  height: 40,
                  width: 240,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                CommonWidgets().text(
                    'For Service or technical support, Please Contact',
                    14.0,
                    FontWeight.w600,
                    TextAlign.center,
                    const Color.fromRGBO(88, 89, 91, 1),
                    "Karbon"),
                const SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: contactInfo.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              contactInfo[i]['icon'],
                              height: 25,
                              width: 25,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 6.0, left: 3.0),
                                child: CommonWidgets().text(
                                    contactInfo[i]['text'],
                                    contactInfo[i]['text'].contains('1800')
                                        ? 18.0
                                        : 16.0,
                                    FontWeight.w600,
                                    TextAlign.center,
                                    contactInfo[i]['text'].contains('1800')
                                        ? const Color.fromRGBO(65, 64, 66, 1)
                                        : const Color.fromRGBO(88, 89, 91, 1),
                                    'Karbon'))
                          ],
                        ),
                        onTap: () async {
                          // currentAddress = await getAddressFromLatLng();

                          if (contactInfo[i]['text'].contains('1800')) {
                            launchUrlString(contactInfo[i]['url']);
                          } else {
                            sendEmail('Support Request', '''
     The system ${bleController.savedDevices.isNotEmpty ? bleController.savedDevices[0]['model'] : ''}: ${bleController.savedDevices.isNotEmpty ? bleController.savedDevices[0]['serial'] : ''} needs technical support
     Registered by <Installer>
     Location is ${bleController.currentAddress}
     Please insert technical details here:

     ''');
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendEmail(emailType, body) async {
    if (bleController.savedDevices.isEmpty) {
      CommonWidgets().errorSnackbar(
        title: '',
        message: 'Please save a device before sending mail.',
      );
    } else {
      var date = DateFormat.yMMMMd('en_US').format(DateTime.now());
      var file = await ImportExportService().readFile();
      debugPrint('file is $file');
      final Email email = Email(
        body: body,
        subject:
            '${bleController.savedDevices.isNotEmpty ? bleController.savedDevices[0]['model'] : ''}: ${bleController.savedDevices.isNotEmpty ? bleController.savedDevices[0]['serial'] : ''} $emailType $date',
        recipients: ['service@actronair.com.au'],
        attachmentPaths: [file],
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
    }
  }
}
