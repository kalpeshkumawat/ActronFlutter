import 'package:airlink/views/connecting_to_device.dart';
import 'package:airlink/views/connection_successfull.dart';
import 'package:airlink/views/deviceScreen/device_details.dart';
import 'package:airlink/views/devices.dart';
import 'package:airlink/views/devices_found.dart';
import 'package:airlink/views/deviceScreen/error_history.dart';
import 'package:airlink/views/deviceScreen/graph.dart';
import 'package:airlink/views/pairing_screen.dart';
import 'package:airlink/views/search_screen.dart';
import 'package:airlink/views/splash_screen.dart';
import 'package:airlink/views/deviceScreen/system_configuration.dart';
import 'package:get/get.dart';
import '../views/deviceScreen/sysOpsScreen/advanced_search.dart';

appRoutes() => [
      GetPage(
        name: '/',
        page: () => const SplashScreen(),
      ),
      GetPage(
        name: '/devices',
        page: () => const Devices(),
      ),
      GetPage(
        name: '/pairing',
        page: () => const PairingScreen(),
      ),
      GetPage(
        name: '/scaning',
        page: () => const SearchScreen(),
      ),
      GetPage(
        name: '/devicesFound',
        page: () => const DevicesFound(),
      ),
      GetPage(
        name: '/connectingToDevice',
        page: () => const ConnectingToDevice(),
      ),
      GetPage(
        name: '/connectionSuccessfull',
        page: () => const ConnectionSuccessfull(),
      ),
      GetPage(
        name: '/deviceDetails',
        page: () => const DeviceDeatails(),
      ),
      GetPage(
        name: '/errorHistory',
        page: () => const ErrorHistory(),
      ),
      GetPage(
        name: '/systemConfiguration',
        page: () => const SystemConfiguration(),
      ),
      GetPage(
        name: '/advancedSearch',
        page: () => const AdvancedSerach(),
      ),
      GetPage(
        name: '/monitoring',
        page: () => const Graph(),
      ),
      GetPage(
        name: '/Commissioning',
        page: () => const SystemConfiguration(),
      ),
    ];
