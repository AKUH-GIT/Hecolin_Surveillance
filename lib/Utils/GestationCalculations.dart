 import '../Model/PreScreeningVisits.dart';

class GestationCalculations
{
  GestationCalculations()
  {

  }

  static Duration GestationalAgeCalculation(String a_strLMPDate)
  {
    DateTime dateLMP=DateTime.parse(a_strLMPDate);
    DateTime currentDate=DateTime.now();

    final Duration gestationalAge=currentDate.difference(dateLMP);
    print((gestationalAge.inDays));

    return gestationalAge;
   }

  static bool IsEligibleForPreScreening(Duration a_gestationalAge)
  {
    bool eligibleForPrescreening=false;
    int maxGestationalDaysForPreScreening=12*7;

    if(a_gestationalAge.inDays<(maxGestationalDaysForPreScreening))
    {
      eligibleForPrescreening=true;
    }

    return eligibleForPrescreening;
  }

  static List<PrescreeningVisits> CalculatePrescreeningVisits(Duration a_durGestationalAge,String a_strVRID)
  {
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

        newGestationalPrescreeningDate =
            newGestationalPrescreeningDate.add(Duration(days: fortnightlyVisits));

        while (newGestationalPrescreeningDate.compareTo(maxGestationalDateForPrescreening) <=
            0) {

          prescreeningVisitModel =
              PrescreeningVisits(a_strVRID, prescreeningText + count.toString()
                  , newGestationalPrescreeningDate, false);
          prescreeningVisitList.add(prescreeningVisitModel);
          newGestationalPrescreeningDate =
              newGestationalPrescreeningDate.add(Duration(days: fortnightlyVisits));
          count++;

    }
      }
      return prescreeningVisitList;
    }
    catch(exception)
    {
      return prescreeningVisitList;
    }
  }

}