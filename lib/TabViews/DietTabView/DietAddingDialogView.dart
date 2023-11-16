import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../DateTimePicker.dart';
import '../../server_info.dart';
import 'DietClass.dart';

class DietAddingDialogView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DietAddingDialogViewState();
}

class DietAddingDialogViewState extends State<DietAddingDialogView> {
  TextEditingController dateTextFieldController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController timeTextFieldController = TextEditingController(
      text: DateFormat('HH:mm:ss').format(DateTime.now()));
  TextEditingController quantityFieldController = TextEditingController();

  String status = '';
  String message = '';

  Map<String, dynamic> food_table = {};

  List<String> food_table_heads = [''];
  List<List> food_table_records = [
    [0, '']
  ];

  List<String> food_list = [];

  String? diet_timestamp;
  int? selected_food_id;
  double? food_quantity;

  Future<void> get_food_id_products_list() async {
    var url = Uri.http(SERVER_HOST, 'tables/food/get_full_food_products_table');
    try {
      var response_get =
          await http.get(url, headers: {'Accept': 'application/json'});
      final response_bytes = response_get.bodyBytes;
      final Map<String, dynamic> response_dict =
          json.decode(utf8.decode(response_bytes));

      food_table = response_dict;
      food_table_heads = food_table['column_names'].cast<String>();
      food_table_records = food_table['records'].cast<List>();

      status = "Success!";
      message = "New urine record inserted!";
      food_list = List<String>.generate(
          food_table_records.length, (index) => food_table_records[index][1]);
      setState(() {});
    } catch (error) {
      status = "Failed!";
      message = "HTTP request failed!";
      print(error);
    }
    print(food_table_records);
  }

  Future<void> submit_diet_record() async {
    try {
      food_quantity = double.parse(quantityFieldController.text);
    } catch (error) {
      status = "Failed!";
      message = "Cannot convert input to Float!";
      food_quantity = 0;
      return;
    }
    var url = Uri.http(SERVER_HOST, 'tables/diet/add_diet_record');
    var to_send = '';
    diet_timestamp =
        '${dateTextFieldController.text} ${timeTextFieldController.text}';
    if (food_quantity != null &&
        diet_timestamp != null &&
        selected_food_id != null) {
      to_send = json.encode({
        "food_id": selected_food_id,
        "food_quantity": food_quantity,
        "diet_timestamp": diet_timestamp
      });
    }
    try {
      var response_post = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: to_send);
      final response = response_post.body;
      final Map<String, dynamic> response_dict = json.decode(response);
      final response_message = response_dict['message'];
      if (response_message == "ok") {
        status = "Success!";
        message = "New diet record inserted!";
      } else {
        status = "Failed!";
        message = response_message;
      }
    } catch (error) {
      status = "Failed!";
      message = "HTTP request failed!";
    }
    print(message);
  }

  @override
  void initState() {
    super.initState();

    get_food_id_products_list();
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
                Diet(timestamp: DateTime.now(), food_id: 1, quantity: 10)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
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
                      selected_food_id = id;
                    },
                    dropdownMenuEntries: food_table_records
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
        child: Icon(Icons.save),
        onPressed: () {
          submit_diet_record().then((value) {
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
