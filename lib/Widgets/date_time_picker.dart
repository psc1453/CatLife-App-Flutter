import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final TextEditingController dateTextFieldController;
  final TextEditingController timeTextFieldController;
  final String datePickerLabel;
  final String timePickerLabel;

  const DateTimePicker(
      {Key? key,
      required this.dateTextFieldController,
      required this.timeTextFieldController,
      this.datePickerLabel = "Enter Date",
      this.timePickerLabel = "Enter Time"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            controller: dateTextFieldController,
            decoration: InputDecoration(
              icon: const Icon(Icons.calendar_today),
              labelText: datePickerLabel,
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                dateTextFieldController.text = formattedDate;
              }
            },
          ),
        ),
        Flexible(
          child: TextFormField(
            controller: timeTextFieldController,
            decoration: InputDecoration(
              icon: const Icon(Icons.schedule),
              labelText: timePickerLabel,
            ),
            readOnly: true,
            onTap: () async {
              BuildContext contextCopy = context;
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                DateTime parsedTime = DateTime.now();
                try {
                  if (context.mounted) {
                    parsedTime = DateFormat("hh:mm a")
                        .parse(pickedTime.format(contextCopy).toString());
                  }
                } on FormatException catch (_) {
                  if (context.mounted) {
                    parsedTime = DateFormat("HH:mm")
                        .parse(pickedTime.format(contextCopy).toString());
                  }
                }
                String formattedTime =
                    DateFormat('HH:mm:ss').format(parsedTime);
                timeTextFieldController.text = formattedTime;
              }
            },
          ),
        )
      ],
    );
  }
}
