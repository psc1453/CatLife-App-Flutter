import 'package:flutter/material.dart';

import '../../DynamicDataTable.dart';

class DietTableView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DietTableViewState();
}

class DietTableViewState extends State<DietTableView> {
  @override
  Widget build(BuildContext context) {
    return DynamicDataTable(tabel_heads: [
      "tabel_heads"
    ], table_rows: [
      ["hello"]
    ]);
  }
}
