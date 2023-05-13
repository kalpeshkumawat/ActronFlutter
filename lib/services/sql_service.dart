import 'dart:io';
import 'package:airlink/controllers/table_names_controller.dart';
import 'package:airlink/models/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlService {
  static final SqlService _sqlService = SqlService._internal();

  factory SqlService() {
    return _sqlService;
  }

  SqlService._internal();

  SqlService._privateConstructor();
  static final SqlService instance = SqlService._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Constants.databaseName);
    return await openDatabase(path,
        version: Constants.databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${TableNamesController.deviceTable} (
            _id INTEGER PRIMARY KEY,
            id TEXT NOT NULL,
            model TEXT NOT NULL,
            serial TEXT NOT NULL,
            iduVersion TEXT NOT NULL,
            oduVersion TEXT NOT NULL,
            name TEXT NOT NULL,
            type INTEGER NOT NULL,
            lastUpdatedDate TEXT,
            comissionedDate TEXT 
          )
          ''');
    await db.execute('''
          CREATE TABLE ${TableNamesController.sysOpsTable} (
            _id INTEGER PRIMARY KEY,
            id TEXT NOT NULL,
            controlMode TEXT ,
            operationMode TEXT ,
            requestCompSpeed TEXT ,
            actualCompSpeed TEXT ,
            statusFlags TEXT ,
            iduFanPercentage TEXT ,
            iduFanRpm TEXT ,
            oduFanSpeed TEXT ,
            oduFanRpm TEXT ,
            iduCoilTemperature TEXT ,
            oduAmbientTemperature TEXT ,
            oduCoilTemperature TEXT ,
            dischargeTemperature TEXT ,
            suctionTemperature TEXT ,
            roomTemperature TEXT ,
            hpPressure TEXT ,
            lpPressure TEXT ,
            exvTarget TEXT ,
            exvPosition TEXT ,
            oduState TEXT ,
            oduStateTime TEXT ,
            superheat TEXT ,
            dischargeSuperheat TEXT,
            reverseValve TEXT ,
            crankCaseHeater TEXT ,
            pfc TEXT ,
            fault TEXT ,
            compRun TEXT 
          )
          ''');
    await db.execute('''
          CREATE TABLE ${TableNamesController.sysConfigTable} (
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
            economiserMode TEXT ,
            economiserTemperatureDifference TEXT ,
            economiserOutsideMinTemperature TEXT ,
            economiserOutsideMaxTemperature TEXT ,
            economiserOutsideMaxHumidity TEXT ,
            economiserOutsideMaxMoisture TEXT ,
            economiserOutsideMaxDewPoint TEXT ,
            economiserOutsideMaxEnthalpy TEXT ,
            economiserEnthalpyDelta TEXT ,
            economiserCO2P1 TEXT ,
            economiserCO2P2 TEXT ,
            economiserCO2DamperP1 TEXT ,
            economiserCO2DamperP2 TEXT 
          )
          ''');
    await db.execute('''
          CREATE TABLE ${TableNamesController.errorsTable} (
            _id INTEGER PRIMARY KEY,
            id TEXT NOT NULL,
            errorCodes [],
            errorTimes [],
            errorDates []
          )
          ''');
  }

  // inserting data
  Future<int> insertData({tableName, insertingData}) async {
    Database db = await instance.database;
    return await db.insert(tableName, insertingData.toJson());
  }

  // read data from table
  Future<List<Map<String, dynamic>>> readData({tableName}) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

// update data in table
  Future<int> updateData(
      {tableName, row, columnToCheck, argumentNeededForUpdation}) async {
    Database db = await instance.database;
    return await db.update(tableName, row,
        where: '$columnToCheck = ?', whereArgs: [argumentNeededForUpdation]);
  }

// delete data from table
  Future<int> deleteData(
      {tableName, columnToCheck, arugumentNeededForDeletion}) async {
    Database db = await instance.database;
    return await db.delete(tableName,
        where: '$columnToCheck = ?', whereArgs: [arugumentNeededForDeletion]);
  }
}
