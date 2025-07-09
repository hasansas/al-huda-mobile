import 'dart:convert';

SubDistrictResponse subDistrictResponseFromJson(String str) =>
    SubDistrictResponse.fromJson(json.decode(str));

String subDistrictResponseToJson(SubDistrictResponse data) =>
    json.encode(data.toJson());

class SubDistrictResponse {
  SubDistrictResponse({
    this.data,
  });

  SubDistrictResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SubDistrict.fromJson(v));
      });
    }
  }

  List<SubDistrict>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

SubDistrict dataFromJson(String str) => SubDistrict.fromJson(json.decode(str));

String dataToJson(SubDistrict data) => json.encode(data.toJson());

class SubDistrict {
  SubDistrict({
    this.subdistrictId,
    this.provinceId,
    this.province,
    this.cityId,
    this.city,
    this.type,
    this.subdistrictName,
    this.postalCode,
  });

  SubDistrict.fromJson(dynamic json) {
    subdistrictId = json['subdistrict_id'];
    provinceId = json['province_id'];
    province = json['province'];
    cityId = json['city_id'];
    city = json['city'];
    type = json['type'];
    subdistrictName = json['subdistrict_name'];
    postalCode = json['postal_code'];
  }

  String? subdistrictId;
  String? provinceId;
  String? province;
  String? cityId;
  String? city;
  String? type;
  String? subdistrictName;
  String? postalCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subdistrict_id'] = subdistrictId;
    map['province_id'] = provinceId;
    map['province'] = province;
    map['city_id'] = cityId;
    map['city'] = city;
    map['type'] = type;
    map['subdistrict_name'] = subdistrictName;
    map['postal_code'] = postalCode;
    return map;
  }
}
