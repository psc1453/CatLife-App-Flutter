import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class DynamicDataTable extends StatelessWidget {
  late final List<String> tabel_heads;
  late final List<List<dynamic>> table_rows;

  DynamicDataTable({
    Key? key,
    required this.tabel_heads,
    required this.table_rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable2(
        columns: <DataColumn2>[
              DataColumn2(label: Text(tabel_heads[0]), fixedWidth: 100)
            ] +
            List<DataColumn2>.generate(
                tabel_heads.length - 1,
                (index) => DataColumn2(
                      label: Text(tabel_heads[index + 1]),
                    )),
        rows: List<DataRow2>.generate(
            table_rows.length,
            (row_index) => DataRow2(
                cells: List<DataCell>.generate(
                    table_rows[row_index].length,
                    (cell_index) => DataCell(
                        Text(table_rows[row_index][cell_index].toString()))))));
  }
}
