import 'dart:convert';

TrackOrderResponse trackOrderResponseFromJson(String str) =>
    TrackOrderResponse.fromJson(json.decode(str));

String trackOrderResponseToJson(TrackOrderResponse data) =>
    json.encode(data.toJson());

class TrackOrderResponse {
  TrackOrderResponse({
    this.rajaongkir,
  });

  TrackOrderResponse.fromJson(dynamic json) {
    rajaongkir = json['rajaongkir'] != null
        ? Rajaongkir.fromJson(json['rajaongkir'])
        : null;
  }

  Rajaongkir? rajaongkir;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (rajaongkir != null) {
      map['rajaongkir'] = rajaongkir?.toJson();
    }
    return map;
  }
}

Rajaongkir rajaongkirFromJson(String str) =>
    Rajaongkir.fromJson(json.decode(str));

String rajaongkirToJson(Rajaongkir data) => json.encode(data.toJson());

class Rajaongkir {
  Rajaongkir({
    this.result,
  });

  Rajaongkir.fromJson(dynamic json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }
}

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  Result({
    this.delivered,
    this.details,
    this.deliveryStatus,
    this.manifest,
  });

  Result.fromJson(dynamic json) {
    delivered = json['delivered'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    deliveryStatus = json['delivery_status'] != null
        ? DeliveryStatus.fromJson(json['delivery_status'])
        : null;
    if (json['manifest'] != null) {
      manifest = [];
      json['manifest'].forEach((v) {
        manifest?.add(Manifest.fromJson(v));
      });
    }
  }

  bool? delivered;
  Details? details;
  DeliveryStatus? deliveryStatus;
  List<Manifest>? manifest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['delivered'] = delivered;
    if (details != null) {
      map['details'] = details?.toJson();
    }
    if (deliveryStatus != null) {
      map['delivery_status'] = deliveryStatus?.toJson();
    }
    if (manifest != null) {
      map['manifest'] = manifest?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Manifest manifestFromJson(String str) => Manifest.fromJson(json.decode(str));

String manifestToJson(Manifest data) => json.encode(data.toJson());

class Manifest {
  Manifest({
    this.manifestCode,
    this.manifestDescription,
    this.manifestDate,
    this.manifestTime,
    this.cityName,
  });

  Manifest.fromJson(dynamic json) {
    manifestCode = json['manifest_code'];
    manifestDescription = json['manifest_description'];
    manifestDate = json['manifest_date'];
    manifestTime = json['manifest_time'];
    cityName = json['city_name'];
  }

  String? manifestCode;
  String? manifestDescription;
  String? manifestDate;
  String? manifestTime;
  String? cityName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['manifest_code'] = manifestCode;
    map['manifest_description'] = manifestDescription;
    map['manifest_date'] = manifestDate;
    map['manifest_time'] = manifestTime;
    map['city_name'] = cityName;
    return map;
  }
}

DeliveryStatus deliveryStatusFromJson(String str) =>
    DeliveryStatus.fromJson(json.decode(str));

String deliveryStatusToJson(DeliveryStatus data) => json.encode(data.toJson());

class DeliveryStatus {
  DeliveryStatus({
    this.status,
    this.podReceiver,
    this.podDate,
    this.podTime,
  });

  DeliveryStatus.fromJson(dynamic json) {
    status = json['status'];
    podReceiver = json['pod_receiver'];
    podDate = json['pod_date'];
    podTime = json['pod_time'];
  }

  String? status;
  String? podReceiver;
  String? podDate;
  String? podTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['pod_receiver'] = podReceiver;
    map['pod_date'] = podDate;
    map['pod_time'] = podTime;
    return map;
  }
}

Details detailsFromJson(String str) => Details.fromJson(json.decode(str));

String detailsToJson(Details data) => json.encode(data.toJson());

class Details {
  Details({
    this.waybillNumber,
    this.waybillDate,
    this.waybillTime,
    this.weight,
    this.origin,
    this.destination,
    this.shippperName,
    this.shipperAddress1,
    this.shipperAddress2,
    this.shipperAddress3,
    this.shipperCity,
    this.receiverName,
    this.receiverAddress1,
    this.receiverAddress2,
    this.receiverAddress3,
    this.receiverCity,
  });

  Details.fromJson(dynamic json) {
    waybillNumber = json['waybill_number'];
    waybillDate = json['waybill_date'];
    waybillTime = json['waybill_time'];
    weight = json['weight'];
    origin = json['origin'];
    destination = json['destination'];
    shippperName = json['shippper_name'];
    shipperAddress1 = json['shipper_address1'];
    shipperAddress2 = json['shipper_address2'];
    shipperAddress3 = json['shipper_address3'];
    shipperCity = json['shipper_city'];
    receiverName = json['receiver_name'];
    receiverAddress1 = json['receiver_address1'];
    receiverAddress2 = json['receiver_address2'];
    receiverAddress3 = json['receiver_address3'];
    receiverCity = json['receiver_city'];
  }

  String? waybillNumber;
  String? waybillDate;
  String? waybillTime;
  String? weight;
  String? origin;
  String? destination;
  String? shippperName;
  String? shipperAddress1;
  String? shipperAddress2;
  String? shipperAddress3;
  String? shipperCity;
  String? receiverName;
  String? receiverAddress1;
  String? receiverAddress2;
  String? receiverAddress3;
  String? receiverCity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['waybill_number'] = waybillNumber;
    map['waybill_date'] = waybillDate;
    map['waybill_time'] = waybillTime;
    map['weight'] = weight;
    map['origin'] = origin;
    map['destination'] = destination;
    map['shippper_name'] = shippperName;
    map['shipper_address1'] = shipperAddress1;
    map['shipper_address2'] = shipperAddress2;
    map['shipper_address3'] = shipperAddress3;
    map['shipper_city'] = shipperCity;
    map['receiver_name'] = receiverName;
    map['receiver_address1'] = receiverAddress1;
    map['receiver_address2'] = receiverAddress2;
    map['receiver_address3'] = receiverAddress3;
    map['receiver_city'] = receiverCity;
    return map;
  }
}
