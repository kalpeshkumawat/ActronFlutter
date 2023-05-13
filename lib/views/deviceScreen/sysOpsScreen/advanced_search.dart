import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/controllers/ble_controller.dart';
import 'package:airlink/controllers/search_list_controller.dart';
import 'package:airlink/services/advanced_search_service.dart';
import 'package:airlink/views/deviceScreen/sysOpsScreen/system_operations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/device_details_controller.dart';

class AdvancedSerach extends StatefulWidget {
  const AdvancedSerach({Key? key}) : super(key: key);

  @override
  State<AdvancedSerach> createState() => _AdvancedSerachState();
}

class _AdvancedSerachState extends State<AdvancedSerach> {
  final searchController = TextEditingController();
  TextEditingController data = TextEditingController();

  final deviceDetailsController =
      Get.find<DeviceDetailsController>(tag: 'deviceDetailsController');
  bool activateSearch = false;
  final bleController = Get.find<BleController>(tag: 'bleController');
  final ScrollController scrollController = ScrollController();
  final searchListController =
      Get.find<SearchListController>(tag: 'searchListController');
  var isHidden = true;

  @override
  void initState() {
    searchListController.searchResult.clear();
    deviceDetailsController.deviceDetailsPage.value = false;
    deviceDetailsController.operationsTillHpPressure.value = false;
    deviceDetailsController.operationsTillVsdMotor.value = false;
    deviceDetailsController.errorsCodesRegistry.value = false;
    deviceDetailsController.errorsDatesRegistry.value = false;
    deviceDetailsController.errorsTimesRegistry.value = false;
    deviceDetailsController.economiserSettingPage.value = false;
    deviceDetailsController.graphPage.value = false;
    deviceDetailsController.advancedSearchPage.value = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'Advanced Search',
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
              Get.to(
                () => const SystemOperations(),
              );
              deviceDetailsController.advancedSearchPage.value = false;
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(
              height: 16.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              color: const Color.fromRGBO(255, 255, 255, 1),
              height: 40.0,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search....',
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.0,
                    color: activateSearch
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                  ),
                  contentPadding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                controller: searchController,
                onTap: () {
                  setState(
                    () {
                      activateSearch = true;
                    },
                  );
                },
                onChanged: (val) {
                  if (searchController.text == '') {
                    searchListController.searchResult.clear();
                  } else {
                    searchOperation(val, deviceDetailsController);
                  }
                },
                onSubmitted: (_) {
                  setState(
                    () {
                      activateSearch = false;
                      // AdvancedSearchService().sendSearchRegisters();
                    },
                  );
                },
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 21.0, vertical: 16.0),
              child: SizedBox(
                // height: MediaQuery.of(context).size.height / 1.5,
                child: Obx(
                  () => searchListController.searchResult.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: CommonWidgets().text(
                                'Search for a parameter by name',
                                14,
                                FontWeight.w400,
                                TextAlign.center,
                                const Color.fromRGBO(88, 89, 91, .7),
                                'Monstserrat'),
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * .75,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            controller: scrollController,
                            itemCount: searchListController.searchResult.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  isHidden = true;
                                  if (searchListController
                                              .searchResult[i].name ==
                                          'ODU Model' ||
                                      searchListController
                                              .searchResult[i].name ==
                                          'ODU Serial' ||
                                      searchListController
                                              .searchResult[i].name ==
                                          'Indoor Model' ||
                                      searchListController
                                              .searchResult[i].name ==
                                          'Indoor Serial') {
                                  } else {
                                    AdvancedSearchService().sendSearchRegisters(
                                        reg: searchListController
                                            .searchResult[i].startIndex,
                                        length: searchListController
                                            .searchResult[i].length);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonWidgets().text(
                                          searchListController
                                              .searchResult[i].name,
                                          14.0,
                                          FontWeight.w500,
                                          TextAlign.start,
                                          Colors.black,
                                          'Karbon'),
                                      Row(
                                        children: [
                                          searchListController
                                                  .searchResult[i].type
                                                  .contains('r/w')
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          CommonWidgets().registerEditDialog(
                                                              context: context,
                                                              data: data,
                                                              label:
                                                                  'please enter ',
                                                              placeholder:
                                                                  searchListController
                                                                      .searchResult[
                                                                          i]
                                                                      .name,
                                                              type: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                                              register: searchListController
                                                                  .searchResult[
                                                                      i]
                                                                  .startIndex),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    size: 14.0,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          searchListController.searchList[i].name
                                                      .contains('Moisture') ||
                                                  searchListController.searchList[i].name
                                                      .contains('Enthalpy') ||
                                                  searchListController.searchList[i].name.contains(
                                                      'Remote temp') ||
                                                  searchListController.searchList[i].name
                                                      .contains('Humidity') ||
                                                  searchListController.searchList[i].name
                                                      .contains('Weighting') ||
                                                  searchListController.searchList[i].name
                                                      .contains(
                                                          'Remote Config') ||
                                                  searchListController.searchList[i].name
                                                      .contains('Zone') ||
                                                  searchListController.searchList[i].name
                                                      .contains(
                                                          'Indoor Serial') ||
                                                  searchListController.searchList[i].name
                                                      .contains(
                                                          'Indoor Model') ||
                                                  searchListController.searchList[i].name
                                                      .contains('Damper')
                                              ? const Icon(
                                                  Icons.priority_high,
                                                  color: Colors.yellow,
                                                )
                                              : CommonWidgets().text(
                                                  searchListController.searchResult[i].value,
                                                  14.0,
                                                  FontWeight.w600,
                                                  TextAlign.end,
                                                  Colors.black,
                                                  'Karbon'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void searchOperation(
      String searchText, DeviceDetailsController deviceDetailsController) {
    searchListController.searchResult.clear();
    for (int i = 0; i < searchListController.searchList.length; i++) {
      var data = searchListController.searchList[i];
      if (data.name.toLowerCase().contains(
            searchText.toLowerCase(),
          )) {
        searchListController.searchResult.add(data);
      } else {
        debugPrint('no data');
      }
    }
  }
}
