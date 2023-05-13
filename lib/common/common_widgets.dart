import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/device_details_controller.dart';
import 'package:airlink/controllers/table_names_controller.dart';
import 'package:airlink/controllers/packet_frame_controller.dart';
import 'package:airlink/models/device_details_model.dart';
import 'package:airlink/services/ble_service.dart';
import 'package:airlink/services/device_db_service.dart';
import 'package:airlink/services/import_export_service.dart';
import 'package:airlink/services/packet_frame_service.dart';
import 'package:airlink/services/sql_service.dart';
import 'package:airlink/services/system_operation_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonWidgets {
  final bleController = Get.find<BleController>(tag: 'bleController');
  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');

  Widget button({name, function, buttonColor, width, height}) {
    return ElevatedButton(
      onPressed: () => function(),
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 14.0),
        textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
        minimumSize: Size(width, height),
      ),
      child: Text(name),
    );
  }

  Widget text({text, size, fontWeight, textColor, fontFamily}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: textColor,
          fontFamily: fontFamily),
    );
  }

  Widget input({
    required TextEditingController data,
    required String label,
    required inputHintText,
    required type,
    submitDeviceNameFunction,
  }) {
    return TextField(
      autofocus: true,
      keyboardType: type,
      controller: data,
      decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          hintText: inputHintText,
          contentPadding: const EdgeInsets.only(bottom: 7.0, left: 5.0)),
      style: const TextStyle(fontSize: 16.0),
      onSubmitted: (_) => deviceDetailsController.advancedSearchPage.value ||
              deviceDetailsController.systemConfigurePage.value ||
              deviceDetailsController.systemOperationsPage.value
          ? null
          : submitDeviceNameFunction(),
    );
  }

  Widget importExportDialog({context, importFunction, exportFunction}) {
    return Dialog(
      alignment: Alignment.center,
      child: Container(
        height: 200.0,
        width: 200.0,
        padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text(
                text: 'Please select an option',
                size: 20.0,
                fontWeight: FontWeight.w600,
                textColor: Theme.of(context).colorScheme.primary,
                fontFamily: 'Karbon'),
            richText(
                name: 'Import',
                color: Colors.black,
                function: importFunction,
                size: 16.0),
            richText(
                name: 'Export',
                color: Colors.black,
                function: exportFunction,
                size: 16.0)
          ],
        ),
      ),
    );
  }

  Widget selectDeviceDialog({
    context,
    required List<DeviceDetailsModel> listOfDevices,
  }) {
    return Dialog(
      alignment: Alignment.center,
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            text(
                text: 'Please select the devices, to export',
                size: 20.0,
                fontWeight: FontWeight.w600,
                textColor: Theme.of(context).colorScheme.primary,
                fontFamily: 'Karbon'),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 130,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 30.0),
                itemCount: listOfDevices.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  return richText(
                      name: listOfDevices[index].name.toString(),
                      color: Colors.black,
                      function: () {
                        debugPrint(
                            'device id for export is ${listOfDevices[index].id}');
                        ImportExportService().exportDataToMail(
                          listOfDevices[index].id,
                        );
                        Navigator.pop(context);
                      },
                      size: 16.0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget operationDialog(
      {operationSelectedValue,
      selectModeSelectedValue,
      operaionList,
      context,
      selectModeList}) {
    return StatefulBuilder(
      builder: (context, setState) => Dialog(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          height: MediaQuery.of(context).size.height * .47,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .33,
                child: ListView.builder(
                  itemCount: operaionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: text(
                          text: operaionList[index],
                          size: 15.0,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.black,
                          fontFamily: 'Karbon'),
                      trailing: Checkbox(
                        shape: const CircleBorder(),
                        value: operationSelectedValue == index,
                        onChanged: (_) {
                          operationSelectedValue = index;
                          debugPrint('change value is $operationSelectedValue');
                          deviceDetailsController.operationModeSelectedValue
                              .value = operationSelectedValue;
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    button(
                        name: 'Submit',
                        function: () async {
                          await SystemOperationServices()
                              .sendOperationModePackets();
                          Navigator.pop(context);
                        },
                        buttonColor: Theme.of(context).colorScheme.primary,
                        width: 100.0,
                        height: 42.0)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget registerEditDialog({
    context,
    data,
    placeholder,
    label,
    type,
    register,
    value,
  }) {
    return Dialog(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .24,
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.5),
              child: input(
                data: data,
                label: label,
                inputHintText: data.text,
                type: type,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                button(
                    name: "Submit",
                    function: () async {
                      print('update data is ${data.text}');
                      if (data.text == '') {
                        errorSnackbar(title: '', message: "Please enter data");
                      } else {
                        var updatedData = int.parse(data.text);
                        if (placeholder.contains('Temperature')) {
                          updatedData = updatedData * 10;
                        }
                        var newData = [
                          1,
                          register,
                          updatedData,
                        ];
                        try {
                          await PacketFrameService().createPacket(newData,
                              PacketFrameController().subopcodeWriteSingle);
                          Navigator.pop(context);
                        } catch (e) {
                          errorSnackbar(
                              title: '', message: "Couldn't send the packets");
                        }
                      }
                      data.text = '';
                    },
                    buttonColor: Theme.of(context).colorScheme.primary,
                    width: 100.0,
                    height: 42.0),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget connectConfirmDialog({context}) {
    return AlertDialog(
      title: const Text('Connect'),
      content: const Text('Do you want to connect to the device?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            const CircularProgressIndicator();
            await BleService().connectToDevice(bleController.selectedDevice!);
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget deleteDeviceDialog({context, id, deviceDetials}) {
    return AlertDialog(
      content: text(
        text: 'Do you want to delete the device?',
        size: 16.0,
        fontWeight: FontWeight.w600,
        textColor: Colors.black,
        fontFamily: 'Karbon',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: text(
            text: 'Cancel',
            size: 14.0,
            fontWeight: FontWeight.w600,
            textColor: Colors.red,
            fontFamily: 'Karbon',
          ),
        ),
        TextButton(
          onPressed: () async {
            await SqlService.instance.deleteData(
              tableName: TableNamesController.deviceTable,
              columnToCheck: 'id',
              arugumentNeededForDeletion: id.toString(),
            );
            await SqlService.instance.deleteData(
              tableName: TableNamesController.sysOpsTable,
              columnToCheck: 'id',
              arugumentNeededForDeletion: id.toString(),
            );
            await SqlService.instance.deleteData(
              tableName: TableNamesController.sysConfigTable,
              columnToCheck: 'id',
              arugumentNeededForDeletion: id.toString(),
            );
            await SqlService.instance.deleteData(
              tableName: TableNamesController.errorsTable,
              columnToCheck: 'id',
              arugumentNeededForDeletion: id.toString(),
            );
            await DeviceDbService().queryDeviceDetails();
            Navigator.pop(context, 'OK');
          },
          child: text(
              text: 'OK',
              size: 14.0,
              fontWeight: FontWeight.w600,
              textColor: Theme.of(context).colorScheme.primary,
              fontFamily: 'Karbon'),
        ),
      ],
    );
  }

  Widget richText({name, color, function, size}) {
    return RichText(
      text: TextSpan(
        text: name,
        style: TextStyle(color: color, fontSize: size),
        recognizer: TapGestureRecognizer()..onTap = () => {function()},
      ),
    );
  }

  Widget bmsConfiguration() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            text(
                text: 'BMS Configuration',
                size: 16.0,
                fontWeight: FontWeight.w600,
                textColor: Colors.black,
                fontFamily: 'Karbon'),
          ],
        ),
      ],
    );
  }

  Widget systemConfigOperationSetting({list, sizedBoxHeight}) {
    return SizedBox(
      height: sizedBoxHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    text: list[i]['label'],
                    size: 14.0,
                    fontWeight: FontWeight.w400,
                    textColor: Colors.black,
                    fontFamily: 'karbon',
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    height: 25.0,
                    child: text(
                      text: list[i]['value'].toString(),
                      size: 14.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.black,
                      fontFamily: 'Karbon',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget systemComnfigurationRowInput({
    list,
    sizedBoxHeight,
  }) {
    return SizedBox(
      height: sizedBoxHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: text(
                      text: list[i]['label'],
                      size: 14.0,
                      fontWeight: FontWeight.w400,
                      textColor: Colors.black,
                      fontFamily: 'karbon',
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .6,
                    height: MediaQuery.of(context).size.height * .03,
                    child: input(
                      data: list[i]['value'].value,
                      label: '',
                      inputHintText: '',
                      type: list[i]['label'] == "Installer"
                          ? TextInputType.text
                          : TextInputType.number,
                      submitDeviceNameFunction: () async {
                        debugPrint('entered into the funciton');
                        if (list[i]['label'].contains('Installer')) {
                        } else {
                          try {
                            await PacketFrameService().createPacket([
                              1,
                              list[i]['label'] == 'Low PWM'
                                  ? 100
                                  : list[i]['label'] == 'Med PWM'
                                      ? 101
                                      : list[i]['label'] == 'High PWM'
                                          ? 102
                                          : list[i]['label'] == 'Low RPM'
                                              ? 103
                                              : list[i]['label'] == 'Med RPM'
                                                  ? 104
                                                  : list[i]['label'] ==
                                                          ' Fan Filter Hours Countdown'
                                                      ? 108
                                                      : 105,
                              int.parse(list[i]['value'].value.text)
                            ], PacketFrameController().subopcodeWriteSingle);
                          } catch (e) {
                            debugPrint('error is ${e.toString()}');
                            errorSnackbar(title: '', message: e.toString());
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SnackbarController succesSnackbar({title, message}) {
    return Get.snackbar(title, message,
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  SnackbarController errorSnackbar({title, message}) {
    return Get.snackbar(title, message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}
