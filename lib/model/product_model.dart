import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.productOldPrice,
    this.productPrice,
    this.productRate,
    this.productName,
    this.productImg,
    this.productDiscount,
    this.productId,
    this.productDescription,
  });

  int productOldPrice;
  int productPrice;
  double productRate;
  String productName;
  String productImg;
  int productDiscount;
  String productId;
  String productDescription;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productOldPrice:
            json["productOldPrice"] == null ? null : json["productOldPrice"],
        productPrice:
            json["productPrice"] == null ? null : json["productPrice"],
        productRate:
            json["productRate"] == null ? null : json["productRate"].toDouble(),
        productName: json["productName"] == null ? null : json["productName"],
        productImg: json["productImg"] == null ? null : json["productImg"],
        productDiscount:
            json["productDiscount"] == null ? null : json["productDiscount"],
        productId: json["productId"] == null ? null : json["productId"],
        productDescription: json["productDescription"] == null
            ? null
            : json["productDescription"],
      );

  Map<String, dynamic> toJson() => {
        "productOldPrice": productOldPrice == null ? null : productOldPrice,
        "productPrice": productPrice == null ? null : productPrice,
        "productRate": productRate == null ? null : productRate,
        "productName": productName == null ? null : productName,
        "productImg": productImg == null ? null : productImg,
        "productDiscount": productDiscount == null ? null : productDiscount,
        "productId": productId == null ? null : productId,
        "productDescription":
            productDescription == null ? null : productDescription,
      };
}
