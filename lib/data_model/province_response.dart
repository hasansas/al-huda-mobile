import 'dart:convert';

ProvinceResponse provinceResponseFromJson(String str) =>
    ProvinceResponse.fromJson(json.decode(str));

String provinceResponseToJson(ProvinceResponse data) =>
    json.encode(data.toJson());

class ProvinceResponse {
  ProvinceResponse({
    this.data,});

  ProvinceResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Province.fromJson(v));
      });
    }
  }

  List<Province>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Province dataFromJson(String str) => Province.fromJson(json.decode(str));

String dataToJson(Province data) => json.encode(data.toJson());

class Province {
  Province({
    this.provinceId,
    this.provinceName,});

  Province.fromJson(dynamic json) {
    provinceId = json['province_id'];
    provinceName = json['province'];
  }

  String? provinceId;
  String? provinceName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['province_id'] = provinceId;
    map['province'] = provinceName;
    return map;
  }

}