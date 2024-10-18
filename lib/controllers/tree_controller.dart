import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tractionchallenge/controllers/assets_controller.dart';
import 'package:tractionchallenge/controllers/companies_controller.dart';
import 'package:tractionchallenge/controllers/locations_controller.dart';
import 'package:tractionchallenge/models/Assets.dart';
import 'package:tractionchallenge/models/Companies.dart';
import 'package:tractionchallenge/models/FullTree.dart';

import '../models/Location.dart';

class TreeController extends GetxController {
  var filtro = <String,String>{};

  var isFiltroEnergy = false.obs;
  var isFiltroCritical = false.obs;

  var isLoading = false.obs;
  var isError = "".obs;
  var tree = Tree(id: '', name: '', sensorType: '', status: '', type: TreeType.asset, level: 0, children: []).obs;

  /* aproach too slow
  var treeList = List<Tree>.empty(growable: true).obs;

  Future<void> buildTree(String companyId)async {
    isLoading.value = true;
    try {
      late Tree company;
      //Companies
      for( var item in Get.find<CompaniesController>().companies.where( (element)=> element.id==companyId).toList(growable: false) ){
        company = Tree(id: item.id,type: TreeType.company, level: 0, children: List<Tree>.empty(growable: true));
      }
      //Location without parent
      for( var item in Get.find<LocationController>().locations.where( (element)=> element.companyId==companyId && element.parentId==null).toList()){
        company.children.add(Tree(id: item.id, type: TreeType.location, level: 0, children: List<Tree>.empty(growable: true)));
      }
      //Generating location until finish all remaning
      List<Location> location = List<Location>.from(Get.find<LocationController>().locations.where((element) => element.companyId==companyId&&element.parentId!=null).toList(growable: false));
      location.sort( (a,b){
        return (a.parentId!.compareTo(b.parentId!));
      });
      var i =0;
      String parentId = "";
      while (i<=location.length-1){
        parentId = location[i].parentId!;
        while ((i<=location.length-1) && (parentId == location[i].parentId!) ){
          Tree? tree = _findChildren(parentId, company);
          if (tree==null){
            company.children.add(Tree(id: location[i].id,type: TreeType.location, level: company.level, children: List<Tree>.empty(growable: true)));
          } else {
            //String titulo = Get.find<LocationController>().locations.singleWhere((element) => element.id==tree.id).name;
            //print("Pai:"+titulo);
            //titulo = Get.find<LocationController>().locations.singleWhere((element) => element.id==location[i].id).name;
            //print("Filho:"+titulo);
            tree.children.add(
                Tree(id: location[i].id, type: TreeType.location, level: tree.level+1, children: List<Tree>.empty(growable: true)));
          }
          i ++;
        }
      }

      // ******
      //Assets
      // *****

      //Assets without parent
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId==null&& element.locationId!=null).toList()){
        Tree? tree = _findChildren(item.locationId!, company);
        tree!.children.add(Tree(id: item.id, type: item.sensorType!=null?TreeType.component:TreeType.asset, level: tree!.level+1, children: List<Tree>.empty(growable: true)));
      }
      //Assets without parent and location
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId==null&& element.locationId==null).toList()){
        company.children.add(Tree(id: item.id,type: item.sensorType!=null?TreeType.component:TreeType.asset, level: 0, children: List<Tree>.empty(growable: true)));
      }
      //Assets with parent and no location
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId!=null&& element.locationId==null).toList()) {
        Tree? tree = _findChildren(item.parentId!, company);
        if (tree==null){
          company.children.add(Tree(id: item.id,type: item.sensorType!=null?TreeType.component:TreeType.asset, level: 0, children: List<Tree>.empty(growable: true)));
        } else {
          tree!.children.add(Tree(id: item.id, type: item.sensorType != null ? TreeType.component : TreeType.asset, level: tree!.level+1, children: List<Tree>.empty(growable: true)));
        }
      }
      //Assets with parent and location
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId!=null&& element.locationId!=null).toList()) {
        Tree? tree = _findChildren(item.parentId!, company);
        if (tree==null){
          company.children.add(Tree(id: item.id,type: item.sensorType!=null?TreeType.component:TreeType.asset, level: 0, children: List<Tree>.empty(growable: true)));
        } else {
          tree!.children.add(Tree(id: item.id, type: item.sensorType != null ? TreeType.component : TreeType.asset, level: 0, children: List<Tree>.empty(growable: true)));
        }
      }

      treeList.add(company);
      Tree lista = Get.find<TreeController>().treeList.firstWhere((element) => element.id==companyId);
      //debugPrint(company.toJson().toString());

    } finally {
      isLoading.value = false;
    }
  }
   */

  void setFiltroEnergy(){
    if (isFiltroEnergy.isTrue){
      filtro.remove("botao");
      isFiltroEnergy.value = false;
    } else {
      filtro["botao"]="energy";
      isFiltroEnergy.value = true;
      isFiltroCritical.value = false;
    }
  }

  void setFiltroCritial(){
    if (isFiltroCritical.isTrue){
      filtro.remove("botao");
      isFiltroCritical.value = false;
    } else {
      filtro["botao"]="alert";
      isFiltroCritical.value = true;
      isFiltroEnergy.value = false;
    }
  }

  _nullToEmpty(String? value){
    return value ?? '';
  }

  setFilter(String chave, String valor){
    filtro[chave] = valor;
  }

  clearFilter(){
    filtro.clear();
  }

  List<T> getFilter<T>( List<T> items, bool Function(T) predicados ){
    return items.where(predicados).toList();
  }

  bool _verifyFilter(Object item, Tree tree){
    if (filtro.isEmpty) {
      return true;
    }
    bool nivelAbaixo = false;

    if (tree.children.isNotEmpty){
      for (var child in tree.children){
        nivelAbaixo = _verifyFilter(item, child);
      }
    }
    bool text = true;
    bool botao = true;
    if (filtro.containsKey("text")) {
      String name = "";
      if (item is Location) {
        name = item.name;
      } else if (item is Assets) {
        name = item.name;
      }

      text = name.toUpperCase().contains(filtro["text"].toString().toUpperCase());
    }
    if (filtro.containsKey("botao")){
      if (item is Assets){
        if (filtro["botao"].toString()=="energy"){
          botao = item.sensorType=="energy";
        } else if (filtro["botao"].toString()=="alert")
          botao = item.status=="alert";
      }
    }

    return nivelAbaixo || (text && botao);
  }

  Future<void> futureBuildTree(String companyId)async {
    isLoading.value = true;
    update();
    //Get.find<CompaniesController>().companyIsLoading(companyId,true);

    try {
      late Tree company;
      //Companies
      for( var item in Get.find<CompaniesController>().companies.where( (element)=> element.id==companyId).toList(growable: false).toList()) {
        company = Tree(id: item.id, name: item.name, sensorType: '',status: '', type: TreeType.company, level: 0, children: List<Tree>.empty(growable: true));
      }
      //Location without parent
      for( var item in Get.find<LocationController>().locations.where( (element)=> element.companyId==companyId && element.parentId==null).toList()){
        if (_verifyFilter(item,company) ){
          company.children.add(Tree(id: item.id,
              name: item.name,
              sensorType: '',
              status: '',
              type: TreeType.location,
              level: 0,
              children: List<Tree>.empty(growable: true)));
        }
      }
      //Generating location until finish all remaning
      List<Location> location = List<Location>.from(Get.find<LocationController>().locations.where((element) => element.companyId==companyId&&element.parentId!=null).toList(growable: false));
      location.sort( (a,b){
        return (a.parentId!.compareTo(b.parentId!));
      });
      var i =0;
      String parentId = "";
      while (i<=location.length-1){
        parentId = location[i].parentId!;
        while ((i<=location.length-1) && (parentId == location[i].parentId!) ){
          Tree? tree = _findChildren(parentId, company);
          if (tree==null){
            if (_verifyFilter(location[i],company) ) {
              company.children.add(Tree(id: location[i].id,
                  name: location[i].name,
                  sensorType: '',
                  status: '',
                  type: TreeType.location,
                  level: company.level,
                  children: List<Tree>.empty(growable: true)));
            }
          } else {
            //String titulo = Get.find<LocationController>().locations.singleWhere((element) => element.id==tree.id).name;
            //print("Pai:"+titulo);
            //titulo = Get.find<LocationController>().locations.singleWhere((element) => element.id==location[i].id).name;
            //print("Filho:"+titulo);
            if (_verifyFilter(location[i],company) ) {
              tree.children.add(
                  Tree(id: location[i].id,
                      name: location[i].name,
                      sensorType: '',
                      status: '',
                      type: TreeType.location,
                      level: tree.level + 1,
                      children: List<Tree>.empty(growable: true)));
            }
          }
          i ++;
        }
      }

      // ******
      //Assets
      // *****

      //Assets without parent
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId==null&& element.locationId!=null).toList()){
        Tree? tree = _findChildren(item.locationId!, company);
        if (tree!=null) {
          if (_verifyFilter(tree,company) ) {
            tree!.children.add(Tree(id: item.id,
                name: item.name,
                sensorType: _nullToEmpty(item.sensorType),
                status: _nullToEmpty(item.status),
                type: item.sensorType != null ? TreeType.component : TreeType
                    .asset,
                level: tree!.level + 1,
                children: List<Tree>.empty(growable: true)));
          }
        }
      }
      //Assets without parent and location
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId==null&& element.locationId==null).toList()){
        if (_verifyFilter(item,company) ) {
          company.children.add(Tree(id: item.id,
              name: item.name,
              sensorType: _nullToEmpty(item.sensorType),
              status: _nullToEmpty(item.status),
              type: item.sensorType != null ? TreeType.component : TreeType
                  .asset,
              level: 0,
              children: List<Tree>.empty(growable: true)));
        }
      }
      //Assets with parent and no location
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId!=null&& element.locationId==null).toList()) {
        Tree? tree = _findChildren(item.parentId!, company);
        if (tree==null){
          if (_verifyFilter(item,company) ) {
            company.children.add(Tree(id: item.id,
                name: item.name,
                sensorType: _nullToEmpty(item.sensorType),
                status: _nullToEmpty(item.status),
                type: item.sensorType != null ? TreeType.component : TreeType
                    .asset,
                level: 0,
                children: List<Tree>.empty(growable: true)));
          }
        } else {
          if (_verifyFilter(item,company) ) {
            tree!.children.add(Tree(id: item.id,
                name: item.name,
                sensorType: _nullToEmpty(item.sensorType),
                status: _nullToEmpty(item.status),
                type: item.sensorType != null ? TreeType.component : TreeType
                    .asset,
                level: tree!.level + 1,
                children: List<Tree>.empty(growable: true)));
          }
        }
      }
      //Assets with parent and location
      for( var item in Get.find<AssetsController>().assets.where( (element)=> element.companyId==companyId && element.parentId!=null&& element.locationId!=null).toList()) {
        Tree? tree = _findChildren(item.parentId!, company);
        if (tree==null){
          if (_verifyFilter(item,company) ) {
            company.children.add(Tree(id: item.id,
                name: item.name,
                sensorType: _nullToEmpty(item.sensorType),
                status: _nullToEmpty(item.status),
                type: item.sensorType != null ? TreeType.component : TreeType
                    .asset,
                level: 0,
                children: List<Tree>.empty(growable: true)));
          }
        } else {
          if (_verifyFilter(item,company) ) {
            tree!.children.add(Tree(id: item.id,
                name: item.name,
                sensorType: _nullToEmpty(item.sensorType),
                status: _nullToEmpty(item.status),
                type: item.sensorType != null ? TreeType.component : TreeType
                    .asset,
                level: 0,
                children: List<Tree>.empty(growable: true)));
          }
        }
      }

      tree.value = company;
      //debugPrint(company.toJson().toString());

    } finally {
      isLoading.value = false;
      //Get.find<CompaniesController>().companyIsLoading(companyId,false);
      update();
    }
  }

  Tree? _findChildren(String parentId, Tree tree){
    if (tree.id==parentId){
      return tree;
    }
    var i = tree.children.indexWhere((element) => element.id==parentId);
    if (i>0){
      return tree.children[i];
    } else {
      for (var child in tree.children){
        Tree? seek = _findChildren(parentId, child);
        if (seek!=null){
          return seek;
        }
      }
    }
  }

}
