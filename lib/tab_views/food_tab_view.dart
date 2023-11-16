import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../refreshable_data_table.dart';
import '../server_info.dart';

class FoodTabView extends StatelessWidget {
  const FoodTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // TODO: Move float button here.
      body: FoodListTableView(),
    );
  }
}

class FoodListTableView extends StatefulWidget {
  const FoodListTableView({super.key});

  @override
  State<StatefulWidget> createState() => FoodListTableViewState();
}

class FoodListTableViewState extends State<FoodListTableView> {
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
      print(error);
    }
  }

  Future<void> addFoodRecord(Food food) async {
    var url = Uri.http(SERVER_HOST, 'tables/food/add_food_record');
    var toSend = json.encode({
      "food_brand": food.brand,
      "food_name": food.name,
      "food_category": food.category,
      "food_unit": food.unit
    });
    try {
      var responsePost = await http.post(url,
          headers: {'Content-Type': 'application/json;charset=utf-8'},
          body: toSend);
      final response = responsePost.body;
      final Map<String, dynamic> responseDict = json.decode(response);
      final responseMessage = responseDict['message'];
      if (responseMessage == "ok") {
        status = "Success!";
        message = "New food inserted!";
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

  Future<void> showFoodAddingDialog() async {
    Food? newFood = await showAdaptiveDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
              child: FoodListAddingDialogView(),
            ));
    if (newFood != null) {
      addFoodRecord(newFood).then((value) {
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
                    status == 'Success!' ? Icons.check_circle : Icons.cancel,
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
      setState(() {
        getFoodList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getFoodList,
        child: RefreshableDataTable(
          tableHeads: foodTableHeads,
          tableRows: foodTableRecords,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showFoodAddingDialog();
        },
      ),
    );
  }
}

class Food {
  final String brand;
  final String name;
  final String category;
  final String unit;

  Food(
      {this.brand = '',
      required this.name,
      required this.category,
      required this.unit});
}

class FoodListAddingDialogView extends StatelessWidget {
  TextEditingController brandTextFieldController = TextEditingController();
  TextEditingController nameTextFieldController = TextEditingController();
  TextEditingController categoryTextFieldController = TextEditingController();
  TextEditingController unitTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close Dialog',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Add a Food"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Data',
            onPressed: () => Navigator.pop(
                context,
                Food(
                    brand: brandTextFieldController.text,
                    name: nameTextFieldController.text,
                    category: categoryTextFieldController.text,
                    unit: unitTextFieldController.text)),
          ),
        ],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Brand?",
                border: OutlineInputBorder(),
              ),
              controller: brandTextFieldController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Name?",
                border: OutlineInputBorder(),
              ),
              controller: nameTextFieldController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Category?",
                border: OutlineInputBorder(),
              ),
              controller: categoryTextFieldController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Unit?",
                border: OutlineInputBorder(),
              ),
              controller: unitTextFieldController,
            ),
          ],
        ),
      )),
    );
  }
}
