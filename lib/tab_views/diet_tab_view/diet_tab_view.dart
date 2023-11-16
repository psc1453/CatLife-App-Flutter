import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../server_info.dart';
import 'diet_class.dart';
import 'diet_table_view.dart';
import 'diet_view_insert_dialog_view.dart';

class DietTabView extends StatefulWidget {
  const DietTabView({super.key});

  @override
  State<StatefulWidget> createState() => DietTabViewState();
}

class DietTabViewState extends State<DietTabView> {
  String status = '';
  String message = '';

  Map<String, dynamic> foodTable = {};

  List<String> foodTableHeads = [''];
  List<List> foodTableRecords = [
    [0, '']
  ];

  List<String> foodList = [];

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

  Future<void> showDietAddingDialog() async {
    Diet? newDiet = await showAdaptiveDialog(
        context: context,
        builder: (context) => const Dialog.fullscreen(
              child: DietViewInsertDialogView(),
            ));
    if (newDiet != null) {
      setState(() {
        getFoodList();
      });
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
      body: const Center(
        child: DietTableView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDietAddingDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
