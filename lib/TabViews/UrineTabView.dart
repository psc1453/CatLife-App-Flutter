import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../server_info.dart';

class UrineTabView extends StatelessWidget {
  String status = '';
  String message = '';

  Future<void> submit_urine_record() async {
    var url = Uri.http(SEVER_HOST, 'tables/urine/add_urine_record');
    var to_send = json.encode({});
    try {
      var response_post = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: to_send);
      final response = response_post.body;
      final Map<String, dynamic> response_dict = json.decode(response);
      final response_message = response_dict['message'];
      if (response_message == "ok") {
        status = "Success!";
        message = "New urine record inserted!";
      } else {
        status = "Failed!";
        message = response_message;
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
          submit_urine_record().then((value) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(status),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
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
        child: const Icon(Icons.wc),
      ),
    );
  }
}