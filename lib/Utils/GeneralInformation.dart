import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

import '../Controller/DeviceInformationController.dart';
import '../Model/DeviceInformation.dart';
import 'Message.dart';

Future<String> getUniqueDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String uniqueId = '';

  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      uniqueId = androidInfo.androidId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      uniqueId = iosInfo.identifierForVendor;
    }
    print("Unique Device Id");
    print(uniqueId);
  } catch (e) {
    print('Failed to get unique device ID: $e');
  }

  return uniqueId;
}
