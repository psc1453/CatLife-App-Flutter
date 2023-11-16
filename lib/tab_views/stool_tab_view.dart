import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../server_info.dart';

class StoolTabView extends StatelessWidget {
  String status = '';
  String message = '';

  Future<void> addStoolRecord() async {
    var url = Uri.http(SERVER_HOST, 'tables/stool/add_stool_record');
    var toSend = json.encode({});
    try {
      var responsePost = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: toSend);
      final response = responsePost.body;
      final Map<String, dynamic> responseDict = json.decode(response);
      final responseMessage = responseDict['message'];
      if (responseMessage == "ok") {
        status = "Success!";
        message = "New stool record inserted!";
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStoolRecord().then((value) {
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
        child: const Icon(Icons.android),
      ),
    );
  }
}
