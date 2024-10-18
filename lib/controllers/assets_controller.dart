import 'package:get/get.dart';

import '../api/tractian-fake.dart';
import '../generic/generic_types.dart';
import '../models/Assets.dart';

class AssetsController extends GetxController{
  List<Assets> assets = List<Assets>.empty(growable: true);

  Future<void> load(String companyId) async {
    ApiReturn ret = await TractianFakeApi().fetchCompanyAssets(companyId);
    if (ret.statusCode==200){
      for (dynamic item in ret.data as List) {
        assets.add(Assets.fromData(companyId,item));
      }
    }
  }
}