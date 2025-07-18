import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/main_helpers.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/middlewares/group_middleware.dart';
import 'package:active_ecommerce_flutter/middlewares/middleware.dart';
import 'package:active_ecommerce_flutter/repositories/aiz_api_response.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  static Future<http.Response> get(
      {required String url,
      Map<String, String>? headers,
      Middleware? middleware,
      GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    headerMap.addAll(currencyHeader);
    if (headers != null) {
      headerMap.addAll(headers);
    }
    // var response = await http.get(uri, headers: headerMap);
    final _chuckerHttpClient = ChuckerHttpClient(http.Client());
    var response = await _chuckerHttpClient.get(uri, headers: headerMap);
    return AIZApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<http.Response> post(
      {required String url,
      Map<String, String>? headers,
      required String body,
      Middleware? middleware,
      GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    headerMap.addAll(currencyHeader);
    if (headers != null) {
      headerMap.addAll(headers);
    }
    // var response = await http.post(uri, headers: headerMap, body: body);
    final _chuckerHttpClient = ChuckerHttpClient(http.Client());
    var response = await _chuckerHttpClient.post(uri, headers: headerMap, body: body);
    return AIZApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<http.Response> delete(
      {required String url,
      Map<String, String>? headers,
      Middleware? middleware,
      GroupMiddleware? groupMiddleWare}) async {
    Uri uri = Uri.parse(url);
    Map<String, String>? headerMap = commonHeader;
    headerMap.addAll(currencyHeader);
    if (headers != null) {
      headerMap.addAll(headers);
    }
    // var response = await http.delete(uri, headers: headerMap);
    final _chuckerHttpClient = ChuckerHttpClient(http.Client());
    var response = await _chuckerHttpClient.delete(uri, headers: headerMap);
    return AIZApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }
}
