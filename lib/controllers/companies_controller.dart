import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tractionchallenge/api/tractian-fake.dart';
import 'package:tractionchallenge/controllers/assets_controller.dart';
import 'package:tractionchallenge/controllers/locations_controller.dart';
import 'package:tractionchallenge/controllers/tree_controller.dart';
import 'package:tractionchallenge/generic/generic_types.dart';
import 'package:tractionchallenge/models/FullTree.dart';

import '../models/Companies.dart';

class CompaniesController extends GetxController{
  var isError = "".obs;
  var isLoading = false.obs;
  var companies = List<Companies>.empty(growable: true).obs;

  Future<void> loadAll() async {
    isLoading.value = true;
    try {
      companies.clear();
      ApiReturn response = await TractianFakeApi().fetchCompanies();
      if (response.statusCode != 200) {
        isError.value = response.data.toString();
      } else {
        isError.value = "";

        //Get.find<TreeController>().treeList.clear();
        Get.find<LocationController>().locations.clear();
        Get.find<AssetsController>().assets.clear();
        for (dynamic item in response.data as List) {
          companies.add(Companies.fromData(item));
          companyIsLoading(item['id'].toString(), true);

          await Get.find<LocationController>().load(item['id'].toString());
          await Get.find<AssetsController>().load(item['id'].toString());

          //Too slow here - make's to future on this widget
          //Get.find<TreeController>().buildTree(companyId);

          companyIsLoading(item['id'].toString(), false);
        }
      }
    } catch (e){
      isError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void companyIsLoading(String id, bool isLoading){
    companies[companies.indexWhere((element) => element.id==id)].loading = isLoading;
    update();
  }

}