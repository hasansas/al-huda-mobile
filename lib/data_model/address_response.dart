// To parse this JSON data, do
//
//     final addressResponse = addressResponseFromJson(jsonString);

import 'dart:convert';

AddressResponse addressResponseFromJson(String str) =>
    AddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddressResponse data) =>
    json.encode(data.toJson());

class AddressResponse {
  AddressResponse({
    this.addresses,
    this.success,
    this.status,
  });

  List<Address>? addresses;
  bool? success;
  int? status;

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
        addresses:
            List<Address>.from(json["data"].map((x) => Address.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Address {
  Address(
      {this.id,
      this.user_id,
      this.address,
      this.country_id,
      this.state_id,
      this.city_id,
      this.province_ro,
      this.city_ro,
      this.sub_district_ro,
      this.country_name,
      this.state_name,
      this.city_name,
      this.province,
      this.city_text,
      this.sub_district,
      this.postal_code,
      this.phone,
      this.set_default,
      this.location_available,
      this.lat,
      this.lang});

  int? id;
  int? user_id;
  String? address;
  int? country_id;
  int? state_id;
  int? city_id;
  int? province_ro;
  int? city_ro;
  int? sub_district_ro;
  String? country_name;
  String? state_name;
  String? city_name;
  String? province;
  String? city_text;
  String? sub_district;
  String? postal_code;
  String? phone;
  int? set_default;
  bool? location_available;
  double? lat;
  double? lang;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        user_id: json["user_id"],
        address: json["address"],
        country_id: json["country_id"],
        state_id: json["state_id"],
        city_id: json["city_id"],
        province_ro: json["province_ro"],
        city_ro: json["city_ro"],
        sub_district_ro: json["subdistrict_ro"],
        country_name: json["country_name"],
        state_name: json["state_name"],
        city_name: json["city_name"],
        province: json["province"],
        city_text: json["city_text"],
        sub_district: json["subdistrict"],
        postal_code: json["postal_code"] == null ? "" : json["postal_code"],
        phone: json["phone"] == null ? "" : json["phone"],
        set_default: json["set_default"],
        location_available: json["location_available"],
        lat: json["lat"],
        lang: json["lang"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "address": address,
        "country_id": country_id,
        "state_id": state_id,
        "city_id": city_id,
        "province_ro": province_ro,
        "city_ro": city_ro,
        "subdistrict_ro": sub_district_ro,
        "country_name": country_name,
        "state_name": state_name,
        "city_name": city_name,
        "province": province,
        "city_text": city_text,
        "subdistrict": sub_district,
        "postal_code": postal_code,
        "phone": phone,
        "set_default": set_default,
        "location_available": location_available,
        "lat": lat,
        "lang": lang,
      };
}
