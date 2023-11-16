import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Widgets/date_time_picker.dart';
import '../../server_info.dart';
import 'diet_class.dart';

class DietViewInsertDialogView extends StatefulWidget {
  const DietViewInsertDialogView({super.key});

  @override
  State<StatefulWidget> createState() => DietViewInsertDialogViewState();
}

class DietViewInsertDialogViewState extends State<DietViewInsertDialogView> {
  TextEditingController dateTextFieldController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController timeTextFieldController = TextEditingController(
      text: DateFormat('HH:mm:ss').format(DateTime.now()));
  TextEditingController quantityFieldController = TextEditingController();

  String status = '';
  String message = '';

  Map<String, dynamic> foodTable = {};

  List<String> foodTableHeads = [''];
  List<List> foodTableRecords = [
    [0, '']
  ];

  List<String> foodList = [];

  String? dietTimeStamp;
  int? selectedFoodID;
  double? foodQuantity;

  Future<void> getFoodList() async {
    var url = Uri.http(SERVER_HOST, 'tables/food/get_full_food_products_table');
    try {
      var responseGet =
          await http.get(url, headers: {'Accept': 'application/json'});
      final responseBytes = responseGet.bodyBytes;
      final Map<String, dynamic> responseDict =
          json.decode(utf8.decode(responseBytes));

      foodTable = responseDict;
      foodTableHeads = foodTable['column_names'].cast<String>();
      foodTableRecords = foodTable['records'].cast<List>();

      status = "Success!";
      message = "New urine record inserted!";
      foodList = List<String>.generate(
          foodTableRecords.length, (index) => foodTableRecords[index][1]);
      setState(() {});
    } catch (error) {
      status = "Failed!";
      message = "HTTP request failed!";
    }
  }

  Future<void> addDietRecord() async {
    try {
      foodQuantity = double.parse(quantityFieldController.text);
    } catch (error) {
      status = "Failed!";
      message = "Cannot convert input to Float!";
      foodQuantity = 0;
      return;
    }
    var url = Uri.http(SERVER_HOST, 'tables/diet/add_diet_record');
    var toSend = '';
    dietTimeStamp =
        '${dateTextFieldController.text} ${timeTextFieldController.text}';
    if (foodQuantity != null &&
        dietTimeStamp != null &&
        selectedFoodID != null) {
      toSend = json.encode({
        "food_id": selectedFoodID,
        "food_quantity": foodQuantity,
        "diet_timestamp": dietTimeStamp
      });
    }
    try {
      var responsePost = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: toSend);
      final response = responsePost.body;
      final Map<String, dynamic> responseDict = json.decode(response);
      final responseMessage = responseDict['message'];
      if (responseMessage == "ok") {
        status = "Success!";
        message = "New diet record inserted!";
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
  void initState() {
    super.initState();

    getFoodList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close Dialog',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Add a Diet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Date',
            onPressed: () => Navigator.pop(context,
                Diet(timeStamp: DateTime.now(), foodID: 1, foodQuantity: 10)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DateTimePicker(
              dateTextFieldController: dateTextFieldController,
              timeTextFieldController: timeTextFieldController,
              datePickerLabel: "Diet Date",
              timePickerLabel: "Diet Time",
            ),
            Flexible(
                child: DropdownMenu<int>(
                    onSelected: (int? id) {
                      selectedFoodID = id;
                    },
                    dropdownMenuEntries: foodTableRecords
                        .map<DropdownMenuEntry<int>>((record) =>
                            DropdownMenuEntry(
                                value: record[0], label: record[1]))
                        .toList())),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "How much eaten?",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              controller: quantityFieldController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          addDietRecord().then((value) {
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
      ),
    );
  }
}
