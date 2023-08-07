import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DeviceInformation {
  String DeviceID = "";

  DeviceInformation(String a_strDeviceID) {
    this.DeviceID = a_strDeviceID;
  }

  DeviceInformation.fromMap(Map<String, dynamic> result)
      : DeviceID = result["DeviceID"];

  // VisitDoneInt = result["VisitDone"];
  Map<String, Object> toMap() {
    return {'DeviceID': DeviceID};
  }
}
