import 'package:flutter/material.dart';

import '../../Widgets/refreshable_data_table.dart';

class DietTableView extends StatelessWidget {
  const DietTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshableDataTable(refreshHandler: () async {}, tableHeads: [
      "tabel_heads"
    ], tableRows: [
      ["hello"]
    ]);
  }
}
