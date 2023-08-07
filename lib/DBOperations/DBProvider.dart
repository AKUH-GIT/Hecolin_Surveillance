import 'dart:io';
import 'package:hecolin_surveillance/Model/PreScreeningVisits.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Utils/Message.dart';
import '../config.dart';

class DBProvider {
  static final DBProvider _instance = new DBProvider.internal();

  factory DBProvider() => _instance;

  static Database? _database;

  //Future<Database> get database async => _database ??= await initDb();

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  DBProvider.internal();

  initDb() async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final Directory? _appDocDir = await getExternalStorageDirectory();

    Directory _appDocDirFolder =
        Directory('${_appDocDir!.path}/hecolinsurveillance/Database/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
    } else {
      //if folder not exists create folder and then return its path
      //final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
      _appDocDirFolder = await _appDocDirFolder.create(recursive: true);
    }
    //String path = join(documentsDirectory.path, "WomenHecolinTrialDatabase.db");
    //String path = join(_appDocDirFolder.path, "WomenHecolinDatabase.db");
    String path = join(_appDocDirFolder.path, AppConfig.databaseName);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Here, you can handle any database migrations if needed.
    // For this example, we will drop the old table and recreate it with the new schema.
    if (newVersion > oldVersion) {
      //await db.execute('DROP TABLE IF EXISTS $tableMyTable');
      await _onCreate(db, newVersion);
    }
  }

  Future _onCreate(Database db, int dbversion) async {
    await db.execute("CREATE TABLE IF NOT EXISTS WomenBaselineInformation ("
        "WBID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "FullName varchar(50),"
        "CompleteAddress varchar(500),"
        "PhoneNumber varchar(50),"
        "Age int,"
        "PartHeight REAL,"
        "PartWeight REAL,"
        "PartBMI REAL"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS WomenPregnancyInformation ("
        "ANCID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "PRISMAEnrol bit,"
        "PRISMAEnrolDate datetime,"
        "LabSamplesCollected bit,"
        "UltrasoundDone bit,"
        "UltrasoundDate date,"
        "EDD date,"
        "LMPDate date,"
        "GestationalWeek int,"
        "GestationalDays int,"
        "NextUltrasoundDate date,"
        "CTU1VisitDate date,"
        "LabResultsDate date,"
        "PrescreeningVisitDate date,"
        "IsPrenatalInfoColl INTEGER,"
        "PrenatalCareLoc varchar(80),"
        "IsFetalBioNor INTEGER," //Yes,No
        "IsAmnioticFluidNor INTEGER," //Yes,No
        "FetAmniSpecText varchar(200),"
        "VisFetAnomaly INTEGER," //Yes,No
        "OthVisAnomaly INTEGER," //Yes,No
        "VisOthAnomalySpecText varchar(200),"
        "PrenatalCareDate date,"
        "UltrasonographDate date"
        ");");

    await db
        .execute("CREATE TABLE IF NOT EXISTS WomenVerbalConsentInformation ("
            "VCID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
            "WBID INTEGER,"
            // "VRID varchar(20),"
            "VRID varchar(20),"
            "MedidataScreeningID varchar(20),"
            "IsCounseled bit,"
            "HasAgreed int,"
            "AgreementReason varchar(500),"
            "HasConsented int,"
            "ConsentReason varchar(500),"
            "FifthAppointmentDate datetime,"
            "HasConsentedFifthDay int,"
            "ConsentReasonFifthDay varchar(500),"
            "TenthAppointmentDate datetime,"
            "HasConsentedTenthDay int,"
            "ConsentReasonTenthDay varchar(500)"
            ");");

    await db.execute(
        "CREATE TABLE IF NOT EXISTS WomenPrescreeningVisitInformation ("
        "VisitID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "TypeOfVisit varchar(20),"
        "VisitDate date,"
        "VisitDone bit"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS SubstanceUse ("
        "SubsUseID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "TobUse INTEGER,"
        "TobProducts INTEGER,"
        "AlcUse INTEGER,"
        "AlcProducts INTEGER"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS MedHistoryInformation ("
        "HistID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "MedHist INTEGER,"
        "MedDisease varchar(200)"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS StaffInformation ("
        "StaffID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "DateOfEntry date,"
        "StaffName varchar(50),"
        "Site varchar(10)"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS VitalSignsInformation ("
        "VitSignID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "VitSignMeas INTEGER,"
        "SysBP INTEGER,"
        "DiasBP INTEGER,"
        "HeartRate INTEGER,"
        "ResRate INTEGER,"
        "FetalHeartRate INTEGER,"
        "BodyTem REAL,"
        "BodyTemColMe INTEGER,"
        "BodyTemColOth varchar(200),"
        "SameVisDate INTEGER,"
        "DateOfTempCollection date,"
        "TimeOfTempCollection date"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS ObstetricHistory ("
        "ObsID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "PrevPreg INTEGER," //Yes,No,Unknown
        "Abortion INTEGER," //Yes,No,Unknown
        "NumPastPreg INTEGER,"
        "Delivery INTEGER" //Yes,No,Unknown
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS FullPhyExamination ("
        "ExamId INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "WBID INTEGER,"
        // "VRID varchar(20),"
        "VRID varchar(20),"
        "MedidataScreeningID varchar(20),"
        "FPEPerformed INTEGER," //Yes,No
        "FRNPReason varchar(500),"
        "SameVisDate INTEGER," //Yes,No
        "OthFEText varchar(500),"
        "DateOfExam date,"
        "BodySys  varchar(50),"
        "Result INTEGER" //Not Done, Normal, Abnormal Non cli, Abnor Clinically Sig
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS DeviceInformation ("
        "DeviceID varchar  PRIMARY KEY  NOT NULL,"
        "DeviceInformation varchar(200)"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS UserInformation ("
        "UserID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "UserName varchar(50),"
        "UserPassword varchar(20)"
        ");");

    List<Map<String, dynamic>> deviceInformation = [
      {'DeviceID': '2d2e85094782e96', 'DeviceInformation': 'Samsung1'},
      {'DeviceID': '936f5625d7863d6', 'DeviceInformation': 'Sidra F58970'},
      {'DeviceID': 'f0cb75ccff5cf700', 'DeviceInformation': 'Samsung3'},
      {'DeviceID': 'c72bcf90d9c13787', 'DeviceInformation': 'F58972'},
      {'DeviceID': 'fd9483411e1d718e', 'DeviceInformation': 'F58973'},
      {'DeviceID': '7bdf21d253348082', 'DeviceInformation': 'F58973'},

      // Add more data as needed
    ];
// Perform the batch insert
    Batch batch = db.batch();

    for (var data in deviceInformation) {
      batch.insert('DeviceInformation', data);
    }
    await batch.commit();

    List<Map<String, dynamic>> userInformation = [
      {'UserName': 'iman', 'UserPassword': '123'},
      {'UserName': 'reda', 'UserPassword': '234'},
      {'UserName': 'mashal', 'UserPassword': 'mashal123@'},
      {'UserName': 'nadia', 'UserPassword': 'nadia123@'},
      {'UserName': 'user1', 'UserPassword': 'user123@'},
      // Add more data as needed
    ];

    Batch batchUser = db.batch();

    for (var data in userInformation) {
      batchUser.insert('UserInformation', data);
    }
    await batchUser.commit();

    await db.execute("CREATE TABLE IF NOT EXISTS HEVInformation ("
        "HEVID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "TypeOfVisit varchar(80),"
        "NumberOfDays INTEGER,"
        "GestationalAgeUL INTEGER,"
        "GestationalAgeLL INTEGER,"
        "VisitWindowUL INTEGER,"
        "VisitWindowLL INTEGER"
        ");");

    List<Map<String, dynamic>> hevInformation = [
      {
        'TypeOfVisit': 'V1',
        'NumberOfDays': 0,
        'GestationalAgeUL': 34,
        'GestationalAgeLL': 14,
        'VisitWindowUL': 0,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'V2',
        'NumberOfDays': 0,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 14,
        'VisitWindowUL': 0,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'HV/PC1',
        'NumberOfDays': 7,
        'GestationalAgeUL': 37,
        'GestationalAgeLL': 15,
        'VisitWindowUL': 3,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'V3',
        'NumberOfDays': 28,
        'GestationalAgeUL': 40,
        'GestationalAgeLL': 18,
        'VisitWindowUL': 7,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'HV/PC2',
        'NumberOfDays': 35,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 19,
        'VisitWindowUL': 3,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'V4',
        'NumberOfDays': 56,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 22,
        'VisitWindowUL': 7,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'V5',
        'NumberOfDays': 56,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 14,
        'VisitWindowUL': 3,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'V6',
        'NumberOfDays': 168,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 14,
        'VisitWindowUL': 7,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'HV/PC3',
        'NumberOfDays': 175,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 14,
        'VisitWindowUL': 3,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'V7',
        'NumberOfDays': 196,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 14,
        'VisitWindowUL': 7,
        'VisitWindowLL': 0
      },
      {
        'TypeOfVisit': 'V8',
        'NumberOfDays': 336,
        'GestationalAgeUL': 36,
        'GestationalAgeLL': 14,
        'VisitWindowUL': 7,
        'VisitWindowLL': 7
      },

      // Add more data as needed
    ];
// Perform the batch insert
    Batch batchHEV = db.batch();

    for (var data in hevInformation) {
      batchHEV.insert('HEVInformation', data);
    }
    await batchHEV.commit();
    // Close the database
    await db.close();
  }

  Future<List<PrescreeningVisits>> retrievePrescreeningSchedule(
      String condition) async {
    final Database db = await initDb();
    final List<Map<String, Object?>> queryResult =
        await db.query('WomenPrescreeningVisitInformation');
    return queryResult.map((e) => PrescreeningVisits.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>?> getPrescreeningDataForToday() async {
    final Database db = await initDb();

    // Get the current date
    DateTime today = DateTime.now();
    // Format the current date as needed (e.g., yyyy-MM-dd)
    String formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    //Query the table with date comparison
    // List<Map<String, dynamic>> result = await db.query(
    //   'WomenPrescreeningVisitInformation',
    //   where: "VisitDate = ?",
    //   whereArgs: [formattedDate],
    // );
    try {
      List<Map<String, dynamic>> result = await db.query(
        'WomenPrescreeningVisitInformation',
        where: "strftime('%Y-%m-%d', VisitDate) = ?",
        whereArgs: [formattedDate],
      );
      // List<Map<String, dynamic>> result =
      // await db.query('WomenPrescreeningVisitInformation');
      await db.close();
      return result;
    } catch (exception) {
      Utils().toastMessage(exception.toString());
      return null;
    }
    // Close the database
    //await db.close();
  }

  Future<List<Map<String, dynamic>>> getDataFromSQLite() async {
    final database = await initDb();

    final results = await database.query('WomenBaselineInformation');
    await database.close();

    return results;
  }
}
