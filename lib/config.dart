import 'package:intl/intl.dart';

class AppConfig {
  static const String applicationName =
      'PRE-SCREENING LOG SHEET – HECOLIN TRIAL-V1';
  static const String apiUrl = 'https://api.example.com';
  static const String errorMessage = "Error encountered: Contact system admin";
  static const String successMessage = "Women Information Saved Successfully";
  static const String databaseName = "WomenHecolinDatabase.db";
  static int maxGestationalDaysForPreScreening = 12 * 7;
  static int tenthGestationalDaysForPreScreening = 10 * 7;
  static DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  static DateFormat dateForApp =
      DateFormat('yyyy-MM-dd'); // Define your desired date format here

  static int fortnightlyVisits = 14;
  static String prescreeningText = "Prescreening";

  static int minpostScreeningVisitAge = 14 * 7;
  static int maxpostScreeningVisitAge = 34 * 7;

//Post Screening Visit Information

// Add more configuration strings as needed
}
