import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get/get.dart';
import 'package:tractionchallenge/components/tree_component.dart';
import 'package:tractionchallenge/controllers/tree_controller.dart';

import '../components/button_component_filter.dart';
import '../controllers/companies_controller.dart';
import '../models/FullTree.dart';

class AssetsPage extends StatefulWidget {
  String companyId;
  AssetsPage({Key? key, required this.companyId}) : super(key: key);

  @override
  State<AssetsPage> createState() => _AssetsPageState();

}

class _AssetsPageState extends State<AssetsPage> {

  @override
  void initState() {
    super.initState();

    load();
  }
  TreeController treeController = Get.find<TreeController>();

  Future<void> load() async {
    await treeController.futureBuildTree(widget.companyId);
  }

  final Debouncer _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    //Tree lista = Get.find<TreeController>().treeList.firstWhere((element) => element.id==companyId);
    return WillPopScope(
      onWillPop: () async { Get.find<TreeController>().clearFilter(); return true;},
        child:
      Scaffold(
      appBar: AppBar(
        title: const Text("Assets"),
      ),
      //body: TreeComponent( tree: lista.children); too slow

      body: GetBuilder<TreeController>(
        builder: (TreeController controller) {
          if (controller.isLoading.isTrue){
            return const CircularProgressIndicator();
          } else if (controller.isError.isNotEmpty){
            return const
              Center( child: Column(
                children:[
                    Icon( Icons.error_outline, size: 50, color: Colors.red,),
                    Text("Occour error while is loading. Please try again...", style: TextStyle(color: Colors.red, fontSize: 20),)
              ]));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: TextField(
                      onChanged: (value) {
                        _debouncer.debounce(
                            duration: const Duration(milliseconds: 500),
                            onDebounce: () {
                              Get.find<TreeController>().setFilter("text", value.toString());
                              load();
                            }
                        );
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Buscar Ativo ou Local',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx (() =>
                    Row(
                      children: [
                        const SizedBox(width: 10,),
                        ButtonFilterComponent(icon: Icons.bolt, label: 'Sensor de Energia', onPressed: () {treeController.setFiltroEnergy();load();},pressed: treeController.isFiltroEnergy.isTrue, ),
                        const SizedBox(width: 10,),
                        ButtonFilterComponent(icon: Icons.error_outline, label: 'Crítico', onPressed: (){treeController.setFiltroCritial();load();}, pressed: treeController.isFiltroCritical.isTrue,)
                      ],
                    )),
                Expanded(child:
                  SingleChildScrollView(
                    child:
                    TreeComponent( tree: controller.tree.value.children)
                ))
              ],
            );
          }
        }
      )

    ));
  }
}
