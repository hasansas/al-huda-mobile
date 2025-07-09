import 'dart:convert';

ShippingCostsResponses shippingCostsResponsesFromJson(String str) =>
    ShippingCostsResponses.fromJson(json.decode(str));

String shippingCostsResponsesToJson(ShippingCostsResponses data) =>
    json.encode(data.toJson());

class ShippingCostsResponses {
  ShippingCostsResponses({
    this.ro,
    this.result,
    this.shippingType,
    this.value,
    this.valueString,
  });

  ShippingCostsResponses.fromJson(dynamic json) {
    if (json['ro'] != null) {
      ro = [];
      json['ro'].forEach((v) {
        ro?.add(Ro.fromJson(v));
      });
    }
    result = json['result'];
    shippingType = json['shipping_type'];
    value = json['value'];
    valueString = json['value_string'];
  }

  List<Ro>? ro;
  bool? result;
  String? shippingType;
  num? value;
  String? valueString;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (ro != null) {
      map['ro'] = ro?.map((v) => v.toJson()).toList();
    }
    map['result'] = result;
    map['shipping_type'] = shippingType;
    map['value'] = value;
    map['value_string'] = valueString;
    return map;
  }
}

Ro roFromJson(String str) => Ro.fromJson(json.decode(str));

String roToJson(Ro data) => json.encode(data.toJson());

class Ro {
  Ro({
    this.couriers,
  });

  Ro.fromJson(dynamic json) {
    couriers =
        json['couriers'] != null ? Couriers.fromJson(json['couriers']) : null;
  }

  Couriers? couriers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (couriers != null) {
      map['couriers'] = couriers?.toJson();
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
    this.courierList,
  });

  Couriers.fromJson(dynamic json) {
    code = json['code'];
    name = json['name'];
    costs = json['costs'];
    if (json['courier_list'] != null) {
      courierList = [];
      json['courier_list'].forEach((v) {
        courierList?.add(CourierList.fromJson(v));
      });
    }
  }

  String? code;
  String? name;
  dynamic costs;
  List<CourierList>? courierList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['name'] = name;
    map['costs'] = costs;
    if (courierList != null) {
      map['courier_list'] = courierList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

CourierList courierListFromJson(String str) =>
    CourierList.fromJson(json.decode(str));

String courierListToJson(CourierList data) => json.encode(data.toJson());

class CourierList {
  CourierList({
    this.service,
    this.description,
    this.cost,
  });

  CourierList.fromJson(dynamic json) {
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
