import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../server_info.dart';
import 'DietAddingDialogView.dart';
import 'DietClass.dart';
import 'DietTableView.dart';

class DietTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DietTabViewState();
}

class DietTabViewState extends State<DietTabView> {
  String status = '';
  String message = '';

  Map<String, dynamic> food_table = {};

  List<String> food_table_heads = [''];
  List<List> food_table_records = [
    [0, '']
  ];

  List<String> food_list = [];

  Future<void> get_food_list() async {
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
  }

  Future<void> show_diet_adding_dialog() async {
    Diet? new_diet = await showAdaptiveDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
              child: DietAddingDialogView(),
            ));
    if (new_diet != null) {
      print(new_diet);
      setState(() {
        get_food_list();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get_food_list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DietTableView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          show_diet_adding_dialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
