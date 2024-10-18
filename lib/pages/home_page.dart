import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractionchallenge/controllers/companies_controller.dart';
import 'package:tractionchallenge/pages/assets_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  CompaniesController companiesController = Get.find<CompaniesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", width: 126,height: 17,),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () => Get.find<CompaniesController>().loadAll(),
        child: Obx( () =>
          companiesController.isError.isNotEmpty
              ?const
          Padding(padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Icon( Icons.error_outline, size: 50, color: Colors.red,),
                Text("Occour error while is loading Companies. Please try again...", overflow: TextOverflow.visible , style: TextStyle(color: Colors.red, fontSize: 20),)
              ]))
          :companiesController.isLoading.isTrue?const Center( child:CircularProgressIndicator()):buildItems(context)
        )
      ),
    ));
  }

  Widget buildItems(BuildContext context){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: companiesController.companies.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(20.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.blue, // Cor de fundo do container
                borderRadius: BorderRadius.circular(5), // Define o raio para bordas arredondadas
              ),
              height: 85,
          child: Center(
          child: GetBuilder<CompaniesController>(
          builder: (CompaniesController controller) =>
              ListTile(
            textColor: Colors.white,
            leading: Padding( padding: const EdgeInsets.only(left: 10), child: Image.asset("assets/images/company.png",color: Colors.white, height: 24,width: 24,),),
            title: Text(
              controller.companies[index].name,style: TextStyle(color: controller.companies[index].loading?Colors.grey:Colors.white),),
            onTap: controller.companies[index].loading?null:() {
                controller.companyIsLoading(controller.companies[index].id,true);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AssetsPage(companyId:controller.companies[index].id)));
                controller.companyIsLoading(controller.companies[index].id,false);
              },
            trailing: controller.companies[index].loading?const SizedBox( height: 10, width: 10,child:CircularProgressIndicator(color: Colors.white,)):null) ,
          ))));
        }
    );
  }
}
