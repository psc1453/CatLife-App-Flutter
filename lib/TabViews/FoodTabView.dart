import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../DynamicDataTable.dart';
import '../server_info.dart';

class FoodTabView extends StatelessWidget {
  const FoodTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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

  Map<String, dynamic> food_table = {};

  List<String> food_table_heads = [''];
  List<List> food_table_records = [
    ['']
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

  Future<void> add_food_to_list(Food food) async {
    var url = Uri.http(SERVER_HOST, 'tables/food/add_food_record');
    var to_send = json.encode({
      "food_brand": food.brand,
      "food_name": food.name,
      "food_category": food.category,
      "food_unit": food.unit
    });
    try {
      var response_post = await http.post(url,
          headers: {'Content-Type': 'application/json;charset=utf-8'},
          body: to_send);
      final response = response_post.body;
      final Map<String, dynamic> response_dict = json.decode(response);
      final response_message = response_dict['message'];
      if (response_message == "ok") {
        status = "Success!";
        message = "New food inserted today!";
      } else {
        status = "Failed!";
        message = response_message;
      }
    } catch (error) {
      status = "Failed!";
      message = "HTTP request failed!";
    }
  }

  @override
  void initState() {
    super.initState();
    get_food_list();
  }

  Future<void> show_food_adding_dialog() async {
    Food? new_food = await showAdaptiveDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
              child: FoodListAddingDialogView(),
            ));
    if (new_food != null) {
      add_food_to_list(new_food);
      setState(() {
        get_food_list();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: get_food_list,
        child: DynamicDataTable(
          tabel_heads: food_table_heads,
          table_rows: food_table_records,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          show_food_adding_dialog();
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
