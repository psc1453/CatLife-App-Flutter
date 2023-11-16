import 'package:flutter/material.dart';

import 'tab_views/diet_tab_view/diet_tab_view.dart';
import 'tab_views/food_tab_view.dart';
import 'tab_views/stool_tab_view.dart';
import 'tab_views/urine_tab_view.dart';
import 'tab_views/weight_tab_view.dart';

void main() => runApp(const CatLife());

class CatLife extends StatelessWidget {
  const CatLife({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CatLife",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.cyan,
        appBarTheme: const AppBarTheme(elevation: 10),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("CatLife"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monitor_weight)),
              Tab(icon: Icon(Icons.lunch_dining)),
              Tab(icon: Icon(Icons.restaurant)),
              Tab(icon: Icon(Icons.wc)),
              Tab(icon: Icon(Icons.android))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WeightTabView(),
            const FoodTabView(),
            DietTabView(),
            UrineTabView(),
            StoolTabView(),
          ],
        ),
      ),
    );
  }
}
