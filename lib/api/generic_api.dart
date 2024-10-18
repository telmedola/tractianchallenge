import 'package:dio/dio.dart';

import '../generic/generic_types.dart';
import '../generic/translate_generic.dart';

abstract class GenericApi {
  late Dio dio;
  final String baseUrl;

  GenericApi({required this.baseUrl,int connectionTimeOut=10, int receiveTimeout=20}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: connectionTimeOut),
      receiveTimeout: Duration(seconds: receiveTimeout),
    ));
  }

  String changeParamToURL(String url, Map<String, dynamic> params) {
    params.forEach((key, value) {
      url = url.replaceAll(':$key', value.toString());
    });
    return url;
  }

  Future<ApiReturn> get(String endpoint, {Map<String, dynamic>? params}) async {
    ApiReturn ret = ApiReturn();
    try {
      final response = await dio.get(endpoint, queryParameters: params);
      ret.setReturn(statusCode: response.statusCode??0, data: response.data);
    } catch (e) {
      ret.setReturn(statusCode: 401, data: translateMsgError(e.toString()));
      //return FlutterError(e.toString());
    }
    return ret;
  }

  Future<ApiReturn> getQueryParams(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    ApiReturn ret = ApiReturn();
    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      ret.setReturn(statusCode: response.statusCode??0, data: response.data);
    } catch (e) {
      ret.setReturn(statusCode: 401, data: translateMsgError(e.toString()));
      //return FlutterError(e.toString());
    }
    return ret;
  }

  Future<ApiReturn> post(String endpoint, Map<String, dynamic> data) async {
    ApiReturn ret = ApiReturn();
    try {
      final response = await dio.post(endpoint, data: data);
      ret.setReturn(statusCode: response.statusCode??0, data: response.data);
    } catch (e) {
      ret.setReturn(statusCode: 401, data: translateMsgError(e.toString()));
      //return FlutterError(e.toString());
    }
    return ret;
  }
}