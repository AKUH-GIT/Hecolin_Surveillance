import 'package:hecolin_surveillance/Controller/HEVInformationController.dart';
import 'package:hecolin_surveillance/Model/HEVInformation.dart';
import 'package:hecolin_surveillance/config.dart';
import 'package:intl/intl.dart';

import '../Model/PreScreeningVisits.dart';

class GestationCalculations {
  GestationCalculations() {}

  static Duration GestationalAgeCalculation(String a_strLMPDate) {
    DateTime dateLMP = DateTime.parse(a_strLMPDate);
    DateTime currentDate = DateTime.now();

    final Duration gestationalAge = currentDate.difference(dateLMP);
    print((gestationalAge.inDays));

    return gestationalAge;
  }

  static bool IsEligibleForPreScreening(Duration a_gestationalAge) {
    bool eligibleForPrescreening = false;
    int maxGestationalDaysForPreScreening = 12 * 7;

    if (a_gestationalAge.inDays < (maxGestationalDaysForPreScreening)) {
      eligibleForPrescreening = true;
    }

    return eligibleForPrescreening;
  }

  static bool IsEligibleForPostScreening(Duration a_gestationalAge) {
    bool eligibleForPostscreening = false;
    int minGestationalDaysForPostScreening = AppConfig.minpostScreeningVisitAge;
    int maxGestationalDaysForPostScreening = AppConfig.maxpostScreeningVisitAge;

    if ((a_gestationalAge.inDays >= minGestationalDaysForPostScreening) &&
        (a_gestationalAge.inDays <= maxGestationalDaysForPostScreening)) {
      eligibleForPostscreening = true;
    }

    return eligibleForPostscreening;
  }

  static List<PrescreeningVisits> CalculatePrescreeningVisits(
      Duration a_durGestationalAge, String a_strVRID) {
    int maxGestationalDaysForPreScreening = 12 * 7;
    int fortnightlyVisits = 14;
    int count = 1;
    DateTime currentDate = DateTime.now();
    DateTime newGestationalPrescreeningDate = DateTime.now();
    DateTime maxGestationalDateForPrescreening = DateTime.now();
    String prescreeningText = "Prescreening";
    PrescreeningVisits prescreeningVisitModel;
    List<PrescreeningVisits> prescreeningVisitList = [];
    int gestationalAgeDiff = 0;

    try {
      if (a_durGestationalAge != null) {
        gestationalAgeDiff =
            maxGestationalDaysForPreScreening - a_durGestationalAge.inDays;
        maxGestationalDateForPrescreening =
            currentDate.add(Duration(days: gestationalAgeDiff));

        newGestationalPrescreeningDate = newGestationalPrescreeningDate
            .add(Duration(days: fortnightlyVisits));

        while (newGestationalPrescreeningDate
                .compareTo(maxGestationalDateForPrescreening) <=
            0) {
          prescreeningVisitModel = PrescreeningVisits(
              a_strVRID,
              prescreeningText + count.toString(),
              newGestationalPrescreeningDate,
              false);
          prescreeningVisitList.add(prescreeningVisitModel);
          //print(newGestationalPrescreeningDate);
          newGestationalPrescreeningDate = newGestationalPrescreeningDate
              .add(Duration(days: fortnightlyVisits));
          count++;
        }
      }
      // print (prescreeningVisitList);
      return prescreeningVisitList;
    } catch (exception) {
      return prescreeningVisitList;
    }
  }

  static String formatDate(DateTime date) {
    // Format the date in "yyyyMMdd" format using DateFormat
    DateFormat dateFormat = AppConfig.dateFormat;
    return dateFormat.format(date);
  }

  static List<PrescreeningVisits> CalculateTenthAndTwelvthPrescreeningVisits(
      Duration a_durGestationalAge, String a_strVRID) {
    DateTime currentDate = DateTime.now();
    DateTime maxGestationalDateForPrescreening = DateTime.now();
    DateTime tenthGestationalDateForPrescreening = DateTime.now();
    String prescreeningText = AppConfig.prescreeningText;
    PrescreeningVisits prescreeningVisitModel;
    List<PrescreeningVisits> prescreeningVisitList = [];
    int gestationalAgeTenthDiff = 0;
    int gestationalAgeTewelvthDiff = 0;

    try {
      if (a_durGestationalAge != null) {
        gestationalAgeTenthDiff =
            AppConfig.tenthGestationalDaysForPreScreening -
                a_durGestationalAge.inDays;
        tenthGestationalDateForPrescreening =
            currentDate.add(Duration(days: gestationalAgeTenthDiff));
        print(tenthGestationalDateForPrescreening);

        // String formattedTenthDate = formatDate(tenthGestationalDateForPrescreening);
        //
        // DateTime parsedTenthDate = DateTime.parse(formattedTenthDate);

        prescreeningVisitModel = PrescreeningVisits(
            a_strVRID,
            prescreeningText + "10",
            tenthGestationalDateForPrescreening,
            false);
        print(prescreeningVisitModel);
        prescreeningVisitList.add(prescreeningVisitModel);

        gestationalAgeTewelvthDiff =
            AppConfig.maxGestationalDaysForPreScreening -
                a_durGestationalAge.inDays;
        maxGestationalDateForPrescreening =
            currentDate.add(Duration(days: gestationalAgeTewelvthDiff));

        // String formattedTwelvthDate = formatDate(tenthGestationalDateForPrescreening);
        //
        // DateTime parsedTwelvthDate = DateTime.parse(formattedTwelvthDate);

        prescreeningVisitModel = PrescreeningVisits(a_strVRID,
            prescreeningText + "12", maxGestationalDateForPrescreening, false);
        // print (prescreeningVisitModel);
        prescreeningVisitList.add(prescreeningVisitModel);
      }

      return prescreeningVisitList;
    } catch (exception) {
      return prescreeningVisitList;
    }
  }

  static Future<List<PrescreeningVisits>> CalculateHEVPostScreeningVisits(
      Duration a_durGestationalAge, String a_strVRID) async {
    HEVInformationController hevInformationController =
        HEVInformationController();
    List<HEVInformation> listHEVInformation = [];
    List<PrescreeningVisits> prescreeningVisitList = [];
    String formattedDate = AppConfig.dateFormat.format(DateTime.now());
    // DateTime todayDate = DateTime.parse(formattedDate);
    DateTime todayDate = DateTime.now();

    PrescreeningVisits prescreeningVisitModel;

    try {
      final List<Map<String, dynamic>>? queryResult =
          await hevInformationController.GetHEVInformation(a_durGestationalAge);

      if (queryResult != null) {
        for (var map in queryResult!) {
          listHEVInformation.add(HEVInformation.fromMap(map));
        }

        for (var hevInformation in listHEVInformation) {
          Duration durationToAdd = Duration(days: hevInformation.NumberOfDays);
          DateTime visitDate = todayDate.add(durationToAdd);

          prescreeningVisitModel = PrescreeningVisits(
              a_strVRID, hevInformation.TypeOfVisit, visitDate, false);
          prescreeningVisitList.add(prescreeningVisitModel);
        }
      }

      return prescreeningVisitList;
    } catch (exception) {
      print(exception);
      return prescreeningVisitList;
    }
  }
}
