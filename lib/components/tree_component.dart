import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractionchallenge/controllers/assets_controller.dart';
import 'package:tractionchallenge/controllers/locations_controller.dart';
import 'package:tractionchallenge/models/Assets.dart';

import '../models/FullTree.dart';

class TreeComponent extends StatelessWidget {
  List<Tree> tree;
  TreeComponent({super.key, required this.tree});

  String _repeat(int level){
    if (level==0){
      return "";
    }
    var i =0;
    String ret = "";
    while (i<(level*2)){
      ret += " ";
      i++;
    }
    return ret;
  }

  String _getTitle(Tree tree){
    if (tree.type==TreeType.location){
      return Get.find<LocationController>().locations.singleWhere((element) => element.id==tree.id).name.replaceAll("  ", " ");
    } else if (tree.type==TreeType.asset||tree.type==TreeType.component){
      return Get.find<AssetsController>().assets.singleWhere((element) => element.id==tree.id).name.trim();
    } else {
      return 'NotFound';
    }
  }

  String _getTypeImage(Tree tree){
    if (tree.type==TreeType.location){
      return 'assets/images/location.png';
    } else if (tree.type==TreeType.asset){
      return 'assets/images/asset.png';
    } else if (tree.type==TreeType.component){
      return 'assets/images/component.png';
    } else{
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child:
      Column(
      children: tree.map((tree) => _buildTree(context,tree)).toList()
    ));
  }

  Widget getIconAsset(Tree tree) {
    if (tree.type == TreeType.asset || tree.type == TreeType.component) {
      Assets asset = Get
          .find<AssetsController>()
          .assets
          .singleWhere((element) => element.id == tree.id);
      if (asset.sensorType != null) {
        if (asset.sensorType == "energy") {
          return Icon(Icons.bolt, size: 20,color: asset.status == "operating" ? Colors.green : Colors.red);
        } else {
          return Icon(Icons.circle, size: 10,color: asset.status == "operating" ? Colors.green : Colors.red);
        }
      } else {
        return const SizedBox.shrink();
      }
    }else {
      return const SizedBox.shrink();
    }
  }


  Widget _buildTree(BuildContext context, Tree tree) {
    if (tree.children.isEmpty){
      String img = _getTypeImage(tree);
      return ListTile(
        title:  Row(
          children: [
            if (img.isNotEmpty)...[
              Text(_repeat(tree.level),style: const TextStyle(fontSize: 12,fontFamily: 'courier new'),),
              Image.asset(img)
            ],
            Row(
                children: [
                  Text(_getTitle(tree)),
                  Center( child: getIconAsset(tree))
                ]
            )],
        )

      );
    } else {
      String img = _getTypeImage(tree);
      return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child:
        ExpansionTile(
          leading: Wrap(
              children: [
              if (img.isNotEmpty)...[
                Text(_repeat(tree.level),style: const TextStyle(fontSize: 12,fontFamily: 'courier new')),
                Image.asset(img)
              ]
            ]
          ),
          title:  Wrap(
            children: [
              Text(_getTitle(tree)),
              getIconAsset(tree)
            ]
          ),
                children: tree.children.map((itens) => _buildTree(context,itens)).toList())
      );
    }
  }
}
