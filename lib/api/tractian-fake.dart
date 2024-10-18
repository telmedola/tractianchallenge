import 'package:tractionchallenge/api/generic_api.dart';

import '../generic/generic_types.dart';

class TractianFakeApi extends GenericApi {
  static final TractianFakeApi _instance = TractianFakeApi._internal();

  TractianFakeApi._internal() : super(baseUrl: "https://fake-api.tractian.com");

  factory TractianFakeApi() {
    return _instance;
  }

  Future<ApiReturn> fetchCompanies() async {
    return get('/companies');
  }

  Future<ApiReturn> fetchCompanyLocations(String companyId) async {
    String endpoint = changeParamToURL('/companies/:companyId/locations', {'companyId': companyId});
    return get(endpoint);
  }

  Future<ApiReturn> fetchCompanyAssets(String companyId) async {
    String endpoint = changeParamToURL('/companies/:companyId/assets', {'companyId': companyId});
    return get(endpoint);
  }

}