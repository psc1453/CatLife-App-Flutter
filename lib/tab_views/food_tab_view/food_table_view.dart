import 'package:flutter/material.dart';

import '../../Widgets/refreshable_data_table.dart';

class FoodTableView extends StatelessWidget {
  final List<String> foodTableHeads;
  final List<List<dynamic>> foodTableRecords;

  final Future<void> Function() refreshHandler;

  const FoodTableView(
      {Key? key,
      required this.foodTableHeads,
      required this.foodTableRecords,
      required this.refreshHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshableDataTable(
        refreshHandler: refreshHandler,
        tableHeads: foodTableHeads,
        tableRows: foodTableRecords,
      ),
    );
  }
}
