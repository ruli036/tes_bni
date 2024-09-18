import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes_bni/routes.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Watchlist',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'watchlist',
      getPages: route,
    );
  }
}
