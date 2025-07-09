// To parse this JSON data, do
//
//     final orderCreateResponse = orderCreateResponseFromJson(jsonString);

import 'dart:convert';

OrderCreateResponse orderCreateResponseFromJson(String str) => OrderCreateResponse.fromJson(json.decode(str));

String orderCreateResponseToJson(OrderCreateResponse data) => json.encode(data.toJson());

class OrderCreateResponse {
  OrderCreateResponse({
    this.combined_order_id,
    this.result,
    this.bank_details,
    this.message,
  });

  int? combined_order_id;
  bool? result;
  BankDetails? bank_details;
  String? message;

  factory OrderCreateResponse.fromJson(Map<String, dynamic> json) => OrderCreateResponse(
    combined_order_id: json["combined_order_id"],
    result: json["result"],
    bank_details: json["bank_details"] == null ? null : BankDetails.fromJson(json["bank_details"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "combined_order_id": combined_order_id,
    "result": result,
    "bank_details": bank_details,
    "message": message,
  };
}

class BankDetails {
  BankDetails({
    this.snapToken,
    this.snapUrl,
  });

  String? snapToken;
  String? snapUrl;

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
    snapToken: json["snapToken"],
    snapUrl: json["snapUrl"],
  );

  Map<String, dynamic> toJson() => {
    "snapToken": snapToken,
    "snapUrl": snapUrl,
  };
}