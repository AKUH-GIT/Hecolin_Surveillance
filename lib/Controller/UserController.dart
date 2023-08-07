import 'package:sqflite/sqflite.dart';

import '../DBOperations/DBProvider.dart';
import '../Model/UserInformation.dart';
import '../WebApi/SendReceiveData.dart';

class UserController {
  // final List<User> users = [];
  //
  // Future<void> fetchUsers() async {
  //   // Fetch data from API
  //   final response = await http.get(Uri.parse('https://api.example.com/users'));
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonUsers = json.decode(response.body);
  //     users.clear();
  //     jsonUsers.forEach((jsonUser) {
  //       final user = User.fromJson(jsonUser);
  //       users.add(user);
  //     });
  //   } else {
  //     throw Exception('Failed to fetch users');
  //   }
  // }

  Future<List<UserInformation>?> fetchUserLoginAndDeviceInformation() async {
    try {
      Future<List<UserInformation>?> userInformationList = fetchLoginData();

      return userInformationList;
    } catch (exception) {
      return null;
    }
  }

  Future<String?> fetchUserLoginAndDeviceTestInformation() async {
    try {
      final response = fetchLoginTestData();
      return response;
    } catch (exception) {
      return null;
    }
  }

  Future<List<UserInformation>> UserLoginInformationOnSqlLite(
      String a_sUserName) async {
    List<UserInformation> userInformationList = [];
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
        'UserInformation',
        where: 'UserName = ? ', // WHERE clause with multiple parameters
        whereArgs: [
          a_sUserName
        ], // Provide values for the parameter placeholders
      );
      await db.close();

      loginInforMap.forEach((map) {
        final visit = UserInformation.fromMap(map);
        userInformationList.add(visit);
      });
    } catch (exception) {}
    return userInformationList;
  }
}
