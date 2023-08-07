import 'dart:convert';
import 'package:hecolin_surveillance/WebApi/webapiconfig.dart';
import 'package:http/http.dart' as http;
import '../Model/UserInformation.dart';

void fetchData() async {
  final apiUrl =
      '10.1.182.65:5002/api/WomenBaselineInformation'; // Replace with your API endpoint URL

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Request succeeded, parse and process the response data
      final responseData = json.decode(response.body);
      // Perform further processing of the response data as needed
      // ...
    } else {
      // Request failed, handle the error
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    // Request exception occurred, handle the error
    print('Error: $e');
  }
}

Future<List<UserInformation>?> fetchLoginData() async {
  //final apiUrl = '10.1.182.65:5002/api/WomenBaselineInformation'; // Replace with your API endpoint URL
  final apiUrl = WebApiConfig.loginURL; // Replace with your API endpoint URL

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Request succeeded, parse and process the response data
      final responseData = json.decode(response.body);
      print(responseData);

      //List<dynamic> dynamicList=responseData as List<dynamic>;
      List<UserInformation> userList = (responseData as List<dynamic>)
          .map((item) => UserInformation.fromJson(item))
          .toList();

      return userList;
      // ...
    } else {
      // Request failed, handle the error
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Request exception occurred, handle the error
    print('Error: $e');
    return null;
  }
}

Future<String?> fetchLoginTestData() async {
  //final apiUrl = '10.1.182.65:5002/api/WomenBaselineInformation'; // Replace with your API endpoint URL
  final apiUrl = WebApiConfig.loginURL; // Replace with your API endpoint URL

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Request succeeded, parse and process the response data
      final responseData = json.decode(response.body);
      print(responseData);

      //List<dynamic> dynamicList=responseData as List<dynamic>;
      // List<UserInformation> userList = (responseData as List<dynamic>).map((item) =>
      //     UserInformation.fromJson(item)).toList();

      return responseData;
      // ...
    } else {
      // Request failed, handle the error
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Request exception occurred, handle the error
    print('Error: $e');
    return null;
  }
}

Future<void> sendDataToWebApi(List<Map<String, dynamic>> data) async {
  final url =
      'http://your-web-api-url.com/api/endpoint'; // Replace with your Web API endpoint
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(data);

  final response =
      await http.post(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    //print('Data sent successfully');
  } else {
    //print('Failed to send data. Status code: ${response.statusCode}');
  }
}
