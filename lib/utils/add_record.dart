import 'dart:convert';

import 'package:http/http.dart' as http;

Future<({String status, String message})> addRecord(
    {required String host,
    required String apiPath,
    required String successMessage,
    required Map<String, dynamic> dictToSend}) async {
  final url = Uri.http(host, apiPath);

  String jsonToSend = json.encode(dictToSend);

  String requestStatus;
  String requestMessage;

  try {
    var responsePost = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonToSend);
    final response = responsePost.body;
    final Map<String, dynamic> responseDict = json.decode(response);
    final responseMessage = responseDict['message'];
    if (responseMessage == "ok") {
      requestStatus = "Success!";
      requestMessage = successMessage;
    } else {
      requestStatus = "Failed!";
      requestMessage = responseMessage;
    }
  } catch (error) {
    requestStatus = "Failed!";
    requestMessage = "HTTP request failed!";
  }

  return (status: requestStatus, message: requestMessage);
}
