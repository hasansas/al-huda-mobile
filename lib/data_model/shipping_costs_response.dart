import 'dart:convert';

ShippingCostsResponse shippingCostsResponseFromJson(String str) =>
    ShippingCostsResponse.fromJson(json.decode(str));

String shippingCostsResponseToJson(ShippingCostsResponse data) =>
    json.encode(data.toJson());

class ShippingCostsResponse {
  ShippingCostsResponse({
    this.result,
    this.shipping_type,
    this.value,
    this.value_string,
    this.couriers,
  });

  ShippingCostsResponse.fromJson(dynamic json) {
    result = json['result'];
    shipping_type = json['shipping_type'];
    value = json['value'];
    value_string = json['value_string'];
    if (json['couriers'] != null) {
      couriers = [];
      json['couriers'].forEach((v) {
        couriers?.add(Couriers.fromJson(v));
      });
    }
  }

  bool? result;
  String? shipping_type;
  num? value;
  String? value_string;
  List<Couriers>? couriers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['shipping_type'] = shipping_type;
    map['value'] = value;
    map['value_string'] = value_string;
    if (couriers != null) {
      map['couriers'] = couriers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Couriers couriersFromJson(String str) => Couriers.fromJson(json.decode(str));

String couriersToJson(Couriers data) => json.encode(data.toJson());

class Couriers {
  Couriers({
    this.code,
    this.name,
    this.costs,
  });

  Couriers.fromJson(dynamic json) {
    code = json['code'];
    name = json['name'];
    if (json['costs'] != null) {
      costs = [];
      json['costs'].forEach((v) {
        costs?.add(Costs.fromJson(v));
      });
    }
  }

  String? code;
  String? name;
  List<Costs>? costs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['name'] = name;
    if (costs != null) {
      map['costs'] = costs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Costs costsFromJson(String str) => Costs.fromJson(json.decode(str));

String costsToJson(Costs data) => json.encode(data.toJson());

class Costs {
  Costs({
    this.service,
    this.description,
    this.cost,
  });

  Costs.fromJson(dynamic json) {
    service = json['service'];
    description = json['description'];
    if (json['cost'] != null) {
      cost = [];
      json['cost'].forEach((v) {
        cost?.add(Cost.fromJson(v));
      });
    }
  }

  String? service;
  String? description;
  List<Cost>? cost;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['service'] = service;
    map['description'] = description;
    if (cost != null) {
      map['cost'] = cost?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Cost costFromJson(String str) => Cost.fromJson(json.decode(str));

String costToJson(Cost data) => json.encode(data.toJson());

class Cost {
  Cost({
    this.value,
    this.etd,
    this.note,
  });

  Cost.fromJson(dynamic json) {
    value = json['value'];
    etd = json['etd'];
    note = json['note'];
  }

  num? value;
  String? etd;
  String? note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['etd'] = etd;
    map['note'] = note;
    return map;
  }
}
