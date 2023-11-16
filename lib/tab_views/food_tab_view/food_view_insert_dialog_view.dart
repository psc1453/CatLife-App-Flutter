import 'package:flutter/material.dart';

import 'food_class.dart';

class FoodViewInsertDialogView extends StatelessWidget {
  final TextEditingController brandTextFieldController =
      TextEditingController();
  final TextEditingController nameTextFieldController = TextEditingController();
  final TextEditingController categoryTextFieldController =
      TextEditingController();
  final TextEditingController unitTextFieldController = TextEditingController();

  FoodViewInsertDialogView({super.key});

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
