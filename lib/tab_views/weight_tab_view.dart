import 'package:flutter/material.dart';

import '../server_info.dart';
import '../utils/add_record.dart';
import '../utils/show_submit_alert_dialog.dart';

class WeightTabView extends StatelessWidget {
  final TextEditingController weightTextFieldController =
      TextEditingController();

  WeightTabView({super.key});

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
          final weight = double.parse(weightTextFieldController.text);
          addRecord(
                  host: SERVER_HOST,
                  apiPath: 'tables/weight/add_weight_record',
                  successMessage: "New weight inserted today!",
                  dictToSend: {"weight": weight})
              .then((requestResult) => showSubmitAlertDialog(
                  context: context, requestResult: requestResult));
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
