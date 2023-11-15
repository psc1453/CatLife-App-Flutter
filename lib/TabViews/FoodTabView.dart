import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../DynamicDataTable.dart';
import '../server_info.dart';

class FoodTabView extends StatelessWidget {
  const FoodTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  @override
  void initState() {
    super.initState();
    get_food_list();
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
        child: const Icon(Icons.refresh),
        onPressed: () {
          get_food_list();
        },
      ),
    );
  }
}
