// To parse this JSON data, do
//
//     final wishlistResponse = wishlistResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

WishlistResponse wishlistResponseFromJson(String str) =>
    WishlistResponse.fromJson(json.decode(str));

String wishlistResponseToJson(WishlistResponse data) =>
    json.encode(data.toJson());

class WishlistResponse {
  WishlistResponse({
    this.wishlist_items,
    this.success,
    this.status,
  });

  List<WishlistItem>? wishlist_items;
  bool? success;
  int? status;

  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      WishlistResponse(
        wishlist_items: List<WishlistItem>.from(
            json["data"].map((x) => WishlistItem.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(wishlist_items!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class WishlistItem {
  WishlistItem({
    this.id,
    this.product,
  });

  int? id;
  Product? product;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json["id"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product!.toJson(),
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.thumbnail_image,
    this.base_price,
    this.rating,
    this.slug,
    this.sales,
    this.shops,
  });

  int? id;
  String? name;
  String? thumbnail_image;
  String? base_price;
  int? rating;
  String? slug;
  int? sales;
  Shops? shops;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        thumbnail_image: json["thumbnail_image"],
        base_price: json["base_price"],
        rating: json["rating"],
        slug: json["slug"],
        sales: json["sales"],
        shops: Shops.fromJson(json["shops"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail_image": thumbnail_image,
        "base_price": base_price,
        "rating": rating,
        "slug": slug,
        "sales": sales,
        "shops": shops!.toJson(),
      };
}

class Shops {
  Shops({
    this.sub_district,
  });

  String? sub_district;

  factory Shops.fromJson(Map<String, dynamic> json) => Shops(
        sub_district: json["subdistrict"],
      );

  Map<String, dynamic> toJson() => {
        "subdistrict": sub_district,
      };
}
