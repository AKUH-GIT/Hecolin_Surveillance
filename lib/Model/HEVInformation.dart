class HEVInformation {
  String TypeOfVisit = "";
  int NumberOfDays = 0;
  int GestationalAgeUL = 0;
  int GestationalAgeLL = 0;
  int VisitWindowUL = 0;
  int VisitWindowLL = 0;

  HEVInformation.fromMap(Map<String, dynamic> result)
      : TypeOfVisit = result["TypeOfVisit"],
        NumberOfDays = result["NumberOfDays"],
        GestationalAgeUL = result["GestationalAgeUL"],
        GestationalAgeLL = result["GestationalAgeLL"],
        VisitWindowUL = result["VisitWindowUL"],
        VisitWindowLL = result["VisitWindowLL"];

  Map<String, Object> toMap() {
    return {
      'TypeOfVisit': TypeOfVisit,
      'NumberOfDays': NumberOfDays,
      'GestationalAgeUL': GestationalAgeUL,
      'GestationalAgeLL': GestationalAgeLL,
      'VisitWindowUL': VisitWindowUL,
      'VisitWindowLL': VisitWindowLL
    };
  }
}
