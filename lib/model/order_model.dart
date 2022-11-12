// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order(
      {this.dayCreate,
      this.orderId,
      this.statusOrder,
      this.totalPrice,
      this.userId});

  DateTime dayCreate;
  String orderId;
  String statusOrder;
  double totalPrice;
  String userId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        dayCreate: json["dayCreate"] == null
            ? null
            : DateTime.parse(json["dayCreate"]),
        orderId: json["orderId"] == null ? null : json["orderId"],
        statusOrder: json["statusOrder"] == null ? null : json["statusOrder"],
        totalPrice:
            json["totalPrice"] == null ? null : json["totalPrice"].toDouble(),
        userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "dayCreate": dayCreate == null ? null : dayCreate.toIso8601String(),
        "orderId": orderId == null ? null : orderId,
        "statusOrder": statusOrder == null ? null : statusOrder,
        "totalPrice": totalPrice == null ? null : totalPrice,
        "userId": userId == null ? null : userId,
      };
}
