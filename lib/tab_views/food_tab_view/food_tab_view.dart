import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../server_info.dart';
import '../../utils/add_record.dart';
import '../../utils/show_submit_alert_dialog.dart';
import 'food_class.dart';
import 'food_table_view.dart';
import 'food_view_insert_dialog_view.dart';

class FoodTabView extends StatefulWidget {
  const FoodTabView({super.key});

  @override
  State<StatefulWidget> createState() => FoodTabViewState();
}

class FoodTabViewState extends State<FoodTabView> {
  String status = '';
  String message = '';

  Map<String, dynamic> foodTable = {};

  List<String> foodTableHeads = [''];
  List<List> foodTableRecords = [
    ['']
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

  Future<void> showFoodAddingDialog() async {
    Food? newFood = await showAdaptiveDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
              child: FoodViewInsertDialogView(),
            ));
    if (newFood != null) {
      final newFoodDict = {
        "food_brand": newFood.brand,
        "food_name": newFood.name,
        "food_category": newFood.category,
        "food_unit": newFood.unit
      };
      addRecord(
              host: SERVER_HOST,
              apiPath: 'tables/food/add_food_record',
              successMessage: "New food inserted!",
              dictToSend: newFoodDict)
          .then((requestResult) => showSubmitAlertDialog(
              context: context, requestResult: requestResult));
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
      body: Center(
        child: FoodTableView(
            foodTableHeads: foodTableHeads,
            foodTableRecords: foodTableRecords,
            refreshHandler: getFoodList),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFoodAddingDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
