import 'dart:io';
import 'package:airlink/models/device_details_model.dart';
import 'package:airlink/models/error_model.dart';
import 'package:airlink/models/system_config_model.dart';
import 'package:airlink/models/system_operations_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DeviceTable {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static String deviceTable = 'deviceTable';
  static String sysOpsTable = 'sysOpsTable';
  static String sysConfigTable = 'sysConfigTable';
  static String errorsTable = 'errorsTable';

  DeviceTable._privateConstructor();
  static final DeviceTable instance = DeviceTable._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $deviceTable (
            _id INTEGER PRIMARY KEY,
            id TEXT NOT NULL,
            model TEXT NOT NULL,
            serial TEXT NOT NULL,
            name TEXT NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $sysOpsTable (
            _id INTEGER PRIMARY KEY,
            id TEXT NOT NULL,
            controlMode TEXT NOT NULL,
            operationMode TEXT NOT NULL,
            requestCompSpeed TEXT NOT NULL,
            actualCompSpeed TEXT NOT NULL,
            statusFlags TEXT NOT NULL,
            iduFanPercent TEXT NOT NULL,
            iduFanRpm TEXT NOT NULL,
            oduFanSpeed TEXT NOT NULL,
            oduFanRpm TEXT NOT NULL,
            iduCoilTemp TEXT NOT NULL,
            oduAmbientTemp TEXT NOT NULL,
            oduCoilTemp TEXT NOT NULL,
            dischargeTemp TEXT NOT NULL,
            suctionTemp TEXT NOT NULL,
            roomTemp TEXT NOT NULL,
            hpPressure TEXT NOT NULL,
            lpPressure TEXT NOT NULL,
            exvTarget TEXT NOT NULL,
            exvPosition TEXT NOT NULL,
            oduState TEXT NOT NULL,
            oduStateTime TEXT NOT NULL,
            superheat TEXT NOT NULL,
            reverseValve TEXT NOT NULL,
            crankCaseHeater TEXT NOT NULL,
            pfc TEXT NOT NULL,
            fault TEXT NOT NULL,
            compRun TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $sysConfigTable (
            _id INTEGER PRIMARY KEY,
              id TEXT NOT NULL,
            lowPwm TEXT ,
            medPwm TEXT ,
            highPwm TEXT ,
            lowRpm TEXT ,
            medRpm TEXT ,
            highRpm TEXT ,
            fanFilterCountdown TEXT ,
            controlMode TEXT ,
            ecoMode TEXT ,
            ecoTempDiff TEXT ,
            ecoOutMinTemp TEXT ,
            ecoOutMaxTemp TEXT ,
            ecoOutMaxHum TEXT ,
            ecoOutMaxMoist TEXT ,
            ecoOutMaxDew TEXT ,
            ecoOutMaxEnthalpy TEXT ,
            ecoEnthalpy TEXT ,
            ecoCo2P1 TEXT ,
            ecoCo2P2 TEXT ,
            ecoCo2DamperP1 TEXT ,
            ecoCo2DamperP2 TEXT 
          )
          ''');
    await db.execute('''
          CREATE TABLE $errorsTable (
            _id INTEGER PRIMARY KEY,
            id TEXT NOT NULL,
            errorCodes [],
            errorTimes [],
            errorDates []
          )
          ''');
  }

// deviceDetails table
  Future<int> insertDeviceDetails(DeviceDetailsModel row) async {
    Database db = await instance.database;
    return await db.insert(deviceTable, row.toJson());
  }

  Future<List<Map<String, dynamic>>> queryDeviceDetailsRows() async {
    Database db = await instance.database;
    return await db.query(deviceTable);
  }

  Future<int> updateDeviceDetails(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['deviceId'];
    return await db
        .update(deviceTable, row, where: 'deviceId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(deviceTable, where: 'deviceId = ?', whereArgs: [id]);
  }

// sysOps table
  Future<int> insertSystemOpsDetails(SystemOperationsModel row) async {
    Database db = await instance.database;
    return await db.insert(sysOpsTable, row.toJson());
  }

  Future<List<Map<String, dynamic>>> querySystemOpsDetails() async {
    Database db = await instance.database;
    return await db.query(sysOpsTable);
  }

// sysConfigDetails table
  Future<int> insertSystemConfigDetails(SystemConfigModel row) async {
    Database db = await instance.database;
    return await db.insert(sysConfigTable, row.toJson());
  }

  Future<List<Map<String, dynamic>>> querySystemConfigDetails() async {
    Database db = await instance.database;
    return await db.query(sysConfigTable);
  }

// error details table
  Future<int> insertErrorDetails(DeviceErrorsModel row) async {
    Database db = await instance.database;
    return await db.insert(errorsTable, row.toJson());
  }

  Future<List<Map<String, dynamic>>> queryErrorDetails() async {
    Database db = await instance.database;
    return await db.query(errorsTable);
  }
}
