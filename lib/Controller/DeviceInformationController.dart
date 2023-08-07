import 'package:hecolin_surveillance/Model/DeviceInformation.dart';
import 'package:sqflite/sqflite.dart';

import '../DBOperations/DBProvider.dart';

class DeviceInformationController {
  Future<List<DeviceInformation>> DeviceInformationOnSqlLite(
      String a_sDeviceId) async {
    List<DeviceInformation> deviceInformationList = [];
    final Database db = await DBProvider().initDb();

    try {
      // final List<Map<String, dynamic>> prescreeningMap = await db.query('WomenPrescreeningVisitInformation');
      // Fetch data from the table based on the WHERE clause with multiple parameters
      // final List<Map<String, dynamic>> prescreeningMap = await db.query(
      //   'WomenPrescreeningVisitInformation',
      //   where: 'VRID = ? AND MedidataScreeningID = ?', // WHERE clause with multiple parameters
      //   whereArgs: [s_VRID, s_medidataScreeningID], // Provide values for the parameter placeholders
      // );
      final List<Map<String, dynamic>> loginInforMap = await db.query(
        'DeviceInformation',
        where: 'DeviceID = ? ', // WHERE clause with multiple parameters
        whereArgs: [
          a_sDeviceId
        ], // Provide values for the parameter placeholders
      );
      await db.close();

      loginInforMap.forEach((map) {
        final visit = DeviceInformation.fromMap(map);
        deviceInformationList.add(visit);
      });
    } catch (exception) {}
    return deviceInformationList;
  }
}
