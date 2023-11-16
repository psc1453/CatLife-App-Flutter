import 'package:flutter/material.dart';

import '../../refreshable_data_table.dart';

class DietTableView extends StatefulWidget {
  const DietTableView({super.key});

  @override
  State<StatefulWidget> createState() => DietTableViewState();
}

class DietTableViewState extends State<DietTableView> {
  @override
  Widget build(BuildContext context) {
    return RefreshableDataTable(tableHeads: [
      "tabel_heads"
    ], tableRows: [
      ["hello"]
    ]);
  }
}
