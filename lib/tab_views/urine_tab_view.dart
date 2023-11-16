import 'package:flutter/material.dart';

import '../server_info.dart';
import '../utils/add_record.dart';
import '../utils/show_submit_alert_dialog.dart';

class UrineTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addRecord(
                  host: SERVER_HOST,
                  apiPath: 'tables/urine/add_urine_record',
                  successMessage: "New urine record inserted!",
                  dictToSend: {})
              .then((requestResult) => showSubmitAlertDialog(
                  context: context, requestResult: requestResult));
        },
        child: const Icon(Icons.wc),
      ),
    );
  }
}
