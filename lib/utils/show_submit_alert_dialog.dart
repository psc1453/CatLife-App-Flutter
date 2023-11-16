import 'package:flutter/material.dart';

Future<T?> showSubmitAlertDialog<T>(
    {required BuildContext context,
    required ({String message, String status}) requestResult}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(requestResult.status),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(requestResult.message),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Icon(
              requestResult.status == 'Success!'
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
}
