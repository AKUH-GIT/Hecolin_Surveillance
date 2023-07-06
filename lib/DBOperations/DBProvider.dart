import 'dart:io';
import 'package:hecolin_surveillance/Model/PreScreeningVisits.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "WomenHecolinTrialDatabase.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int dbversion) async {

    await db.execute("CREATE TABLE IF NOT EXISTS WomenBaselineInformation ("
        "VRID varchar(20) PRIMARY KEY NOT NULL,"
        "MedidataScreeningID varchar(20),"
        "FullName varchar(50),"
        "CompleteAddress varchar(50),"
        "PhoneNumber varchar(50),"
        "Age int"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS WomenPregnancyInformation ("
        "ANCID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "VRID varchar(20),"
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
        "PrescreeningVisitDate date"
        ");");

    await db.execute("CREATE TABLE IF NOT EXISTS WomenVerbalConsentInformation ("
        "VCID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "VRID varchar(20),"
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

    await db.execute("CREATE TABLE IF NOT EXISTS WomenPrescreeningVisitInformation ("
        "VisitID INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "VRID varchar(20),"
        "TypeOfVisit varchar(20),"
        "VisitDate date,"
        "VisitDone bit"
        ");");
  }

  Future<List<PrescreeningVisits>> retrievePrescreeningSchedule(String condition) async {
    final Database db = await initDb();
    final List<Map<String, Object?>> queryResult = await db.query('WomenPrescreeningVisitInformation');
    return queryResult.map((e) => PrescreeningVisits.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getPrescreeningDataForToday() async {
    final Database db = await initDb();


    // Get the current date
    DateTime today = DateTime.now();

    // Format the current date as needed (e.g., yyyy-MM-dd)
    String formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // Query the table with date comparison
    List<Map<String, dynamic>> result = await db.query(
      'WomenPrescreeningVisitInformation',
      where: "VisitDate = ?",
      whereArgs: [formattedDate],
    );
    // List<Map<String, dynamic>> result  =
    // await db.query('WomenPrescreeningVisitInformation');

    // Close the database
    await db.close();

    return result;
  }
}
