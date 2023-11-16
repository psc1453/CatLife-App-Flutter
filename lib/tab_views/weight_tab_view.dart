import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../server_info.dart';

class WeightTabView extends StatelessWidget {
  TextEditingController weightTextFieldController = TextEditingController();
  double weight = 0;

  String status = '';
  String message = '';

  Future<void> addWeightRecord() async {
    try {
      weight = double.parse(weightTextFieldController.text);
    } catch (error) {
      status = "Failed!";
      message = "Cannot convert input to Float!";
      weight = 0;
      return;
    }
    var url = Uri.http(SERVER_HOST, 'tables/weight/add_weight_record');
    var toSend = json.encode({"weight": weight});
    try {
      var responsePost = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: toSend);
      final response = responsePost.body;
      final Map<String, dynamic> responseDict = json.decode(response);
      final responseMessage = responseDict['message'];
      if (responseMessage == "ok") {
        status = "Success!";
        message = "New weight inserted today!";
      } else {
        status = "Failed!";
        message = responseMessage;
      }
    } catch (error) {
      status = "Failed!";
      message = "HTTP request failed!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "What is the weight today?",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            controller: weightTextFieldController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addWeightRecord().then((value) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(status),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Icon(
                        status == 'Success!'
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 80,
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}