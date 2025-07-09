import 'dart:convert';

CityNewResponse cityNewResponseFromJson(String str) =>
    CityNewResponse.fromJson(json.decode(str));

String cityNewResponseToJson(CityNewResponse data) =>
    json.encode(data.toJson());

class CityNewResponse {
  CityNewResponse({
    this.data,
  });

  CityNewResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CityNew.fromJson(v));
      });
    }
  }

  List<CityNew>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

CityNew dataFromJson(String str) => CityNew.fromJson(json.decode(str));

String dataToJson(CityNew data) => json.encode(data.toJson());

class CityNew {
  CityNew({
    this.cityId,
    this.provinceId,
    this.province,
    this.type,
    this.cityName,
    this.postalCode,
  });

  CityNew.fromJson(dynamic json) {
    cityId = json['city_id'];
    provinceId = json['province_id'];
    province = json['province'];
    type = json['type'];
    cityName = json['city_name'];
    postalCode = json['postal_code'];
  }

  String? cityId;
  String? provinceId;
  String? province;
  String? type;
  String? cityName;
  String? postalCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city_id'] = cityId;
    map['province_id'] = provinceId;
    map['province'] = province;
    map['type'] = type;
    map['city_name'] = cityName;
    map['postal_code'] = postalCode;
    return map;
  }
}
