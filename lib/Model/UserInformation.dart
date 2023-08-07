class UserInformation {
  int UserID;
  String UserName;
  String UserPassword;
  String DeviceInformation;

  UserInformation(
      {required this.UserID,
      required this.UserName,
      required this.UserPassword,
      required this.DeviceInformation});

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      UserInformation(
          UserID: json["userId"],
          UserName: json["userName"],
          UserPassword: json["userPassword"],
          DeviceInformation: json["DeviceInformation"]);

  Map<String, dynamic> toJson() => {
        "UserID": UserID,
        "UserName": UserName,
        "UserPassword": UserPassword,
        "DeviceInformation": DeviceInformation
      };

  UserInformation.fromMap(Map<String, dynamic> result)
      : UserID = result["UserID"],
        UserName = result["UserName"],
        UserPassword = result["UserPassword"],
        DeviceInformation = "";

  // VisitDoneInt = result["VisitDone"];
  Map<String, Object> toMap() {
    return {
      'UserID': UserID,
      'UserName': UserName,
      'UserPassword': UserPassword,
      DeviceInformation: ''
    };
  }
}
