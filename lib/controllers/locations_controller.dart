import 'package:get/get.dart';
import 'package:tractionchallenge/api/tractian-fake.dart';
import 'package:tractionchallenge/generic/generic_types.dart';
import 'package:tractionchallenge/models/Location.dart';

class LocationController extends GetxController{
  List<Location> locations = List<Location>.empty(growable: true);

  Future<void> load(String companyId) async {
    ApiReturn ret = await TractianFakeApi().fetchCompanyLocations(companyId);
    if (ret.statusCode==200){
      for (dynamic item in ret.data as List) {
        locations.add(Location.fromData(companyId,item));
      }
    }
  }
}