import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class RefreshableDataTable extends StatelessWidget {
  late final List<String> tableHeads;
  late final List<List<dynamic>> tableRows;

  RefreshableDataTable({
    Key? key,
    required this.tableHeads,
    required this.tableRows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable2(
        columns: <DataColumn2>[
          DataColumn2(label: Text(tableHeads[0]), fixedWidth: 100)
            ] +
            List<DataColumn2>.generate(
                tableHeads.length - 1,
                (index) => DataColumn2(
                      label: Text(tableHeads[index + 1]),
                    )),
        rows: List<DataRow2>.generate(
            tableRows.length,
            (rowIndex) => DataRow2(
                cells: List<DataCell>.generate(
                    tableRows[rowIndex].length,
                    (cellIndex) => DataCell(
                        Text(tableRows[rowIndex][cellIndex].toString()))))));
  }
}
