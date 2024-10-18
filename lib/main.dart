import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractionchallenge/controllers/assets_controller.dart';
import 'package:tractionchallenge/controllers/companies_controller.dart';
import 'package:tractionchallenge/controllers/locations_controller.dart';
import 'package:tractionchallenge/controllers/tree_controller.dart';
import 'package:tractionchallenge/pages/home_page.dart';

void main() {
  Get.put(CompaniesController());
  Get.put(LocationController());
  Get.put(AssetsController());
  Get.put(TreeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero,Get.find<CompaniesController>().loadAll);

    return MaterialApp(
      title: 'Tractian Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        fontFamily: 'Hug',
        appBarTheme: const AppBarTheme(color: Colors.black,toolbarHeight: 48,
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            toolbarTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData( color: Colors.white,),

        ),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

