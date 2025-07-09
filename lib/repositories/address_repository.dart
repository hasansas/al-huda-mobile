import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/address_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_make_default_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_in_cart_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_location_response.dart';
import 'package:active_ecommerce_flutter/data_model/address_update_response.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/middlewares/banned_user.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';

import '../data_model/city_new_response.dart';
import '../data_model/province_response.dart';
import '../data_model/shipping_costs_response.dart';
import '../data_model/shipping_costs_responses.dart';
import '../data_model/sub_district_response.dart';

class AddressRepository {
  Future<dynamic> getAddressList() async {
    String url = ("${AppConfig.BASE_URL}/user/shipping/address");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );
    return addressResponseFromJson(response.body);
  }

  Future<dynamic> getHomeDeliveryAddress() async {
    String url = ("${AppConfig.BASE_URL}/get-home-delivery-address");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    return addressResponseFromJson(response.body);
  }

  Future<dynamic> getAddressAddResponse(
      {required String address,
      required String province,
      required String city,
      required String sub_district,
      required String province_ro,
      required String city_ro,
      required String sub_district_ro,
      required String postal_code,
      required String phone}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "address": "$address",
      "province": "$province",
      "city_text": "$city",
      "subdistrict": "$sub_district",
      "province_ro": "$province_ro",
      "city_ro": "$city_ro",
      "subdistrict_ro": "$sub_district_ro",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });

    String url = ("${AppConfig.BASE_URL}/user/shipping/create");
    final response = await ApiRequest.post(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
      body: post_body,
      middleware: BannedUser(),
    );
    return addressAddResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateResponse(
      {required int? id,
      required String address,
      required String province,
      required String city,
      required String sub_district,
      required String province_ro,
      required String city_ro,
      required String sub_district_ro,
      required String postal_code,
      required String phone}) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "address": "$address",
      "province": "$province",
      "city_text": "$city",
      "subdistrict": "$sub_district",
      "province_ro": "$province_ro",
      "city_ro": "$city_ro",
      "subdistrict_ro": "$sub_district_ro",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });

    String url = ("${AppConfig.BASE_URL}/user/shipping/update");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return addressUpdateResponseFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateLocationResponse(
    int? id,
    double? latitude,
    double? longitude,
  ) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "latitude": "$latitude",
      "longitude": "$longitude"
    });

    String url = ("${AppConfig.BASE_URL}/user/shipping/update-location");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return addressUpdateLocationResponseFromJson(response.body);
  }

  Future<dynamic> getAddressMakeDefaultResponse(
    int? id,
  ) async {
    var post_body = jsonEncode({
      "id": "$id",
    });

    String url = ("${AppConfig.BASE_URL}/user/shipping/make_default");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body,
        middleware: BannedUser());
    return addressMakeDefaultResponseFromJson(response.body);
  }

  Future<dynamic> getAddressDeleteResponse(
    int? id,
  ) async {
    String url = ("${AppConfig.BASE_URL}/user/shipping/delete/$id");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser());

    return addressDeleteResponseFromJson(response.body);
  }

  Future<dynamic> getCityListByState({state_id = 0, name = ""}) async {
    String url =
        ("${AppConfig.BASE_URL}/cities-by-state/${state_id}?name=${name}");
    final response = await ApiRequest.get(url: url, middleware: BannedUser());
    return cityResponseFromJson(response.body);
  }

  Future<dynamic> getStateListByCountry({country_id = 0, name = ""}) async {
    String url =
        ("${AppConfig.BASE_URL}/states-by-country/${country_id}?name=${name}");
    final response = await ApiRequest.get(url: url, middleware: BannedUser());
    return myStateResponseFromJson(response.body);
  }

  Future<dynamic> getCountryList({name = ""}) async {
    String url = ("${AppConfig.BASE_URL}/countries?name=${name}");
    final response = await ApiRequest.get(url: url, middleware: BannedUser());
    return countryResponseFromJson(response.body);
  }

  Future<dynamic> getProvinceList({name = ""}) async {
    String url =
        ("${AppConfig.RAW_BASE_URL}/rajaongkir/provinces?name=${name}");
    final response = await ApiRequest.get(
      url: url,
    );
    return provinceResponseFromJson(response.body);
  }

  Future<dynamic> getCityList({province_id = 0, name = ""}) async {
    String url =
        ("${AppConfig.RAW_BASE_URL}/rajaongkir/city/${province_id}?name=${name}");
    final response = await ApiRequest.get(url: url);
    return cityNewResponseFromJson(response.body);
  }

  Future<dynamic> getSubDistrictList({city_id = 0, name = ""}) async {
    String url =
        ("${AppConfig.RAW_BASE_URL}/rajaongkir/subdistrict/${city_id}?name=${name}");
    final response = await ApiRequest.get(url: url);
    return subDistrictResponseFromJson(response.body);
  }

  Future<dynamic> getShippingCostResponse(
      {shipping_type = "", service = "", cost = ""}) async {
    // var post_body = jsonEncode({"seller_list": shipping_type});
    var post_body;

    String url = ("${AppConfig.BASE_URL}/shipping_cost");
    if (guest_checkout_status.$ && !is_logged_in.$) {
      if (service == "" && cost == "") {
        post_body = jsonEncode({
          "temp_user_id": temp_user_id.$,
          "seller_list": shipping_type,
        });
      } else {
        post_body = jsonEncode({
          "temp_user_id": temp_user_id.$,
          "seller_list": shipping_type,
          "service": service,
          "cost": cost
        });
      }
    } else {
      if (service == "" && cost == "") {
        post_body = jsonEncode({
          "user_id": user_id.$,
          "seller_list": shipping_type,
        });
      } else {
        post_body = jsonEncode({
          "user_id": user_id.$,
          "seller_list": shipping_type,
          "service": service,
          "cost": cost
        });
      }
    }
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body,
        middleware: BannedUser());
    return shippingCostsResponsesFromJson(response.body);
  }

  Future<dynamic> getAddressUpdateInCartResponse(
      {int? address_id = 0, int pickup_point_id = 0}) async {
    var post_body = jsonEncode({
      "address_id": "$address_id",
      "pickup_point_id": "$pickup_point_id",
      "user_id": "${user_id.$}"
    });

    String url = ("${AppConfig.BASE_URL}/update-address-in-cart");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());

    return addressUpdateInCartResponseFromJson(response.body);
  }

  Future<dynamic> getShippingTypeUpdateInCartResponse(
      {required int shipping_id, shipping_type = "home_delivery"}) async {
    var post_body = jsonEncode({
      "shipping_id": "$shipping_id",
      "shipping_type": "$shipping_type",
    });

    String url = ("${AppConfig.BASE_URL}/update-shipping-type-in-cart");

    print(url.toString());
/*    print(post_body.toString());
    print(access_token.$.toString());*/
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());

    return addressUpdateInCartResponseFromJson(response.body);
  }
}
