// To parse this JSON data, do
//
//     final productMiniResponse = productMiniResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

ProductMiniResponse productMiniResponseFromJson(String str) =>
    ProductMiniResponse.fromJson(json.decode(str));

String productMiniResponseToJson(ProductMiniResponse data) =>
    json.encode(data.toJson());

class ProductMiniResponse {
  ProductMiniResponse({
    this.products,
    this.meta,
    this.success,
    this.status,
  });

  List<Product>? products;
  bool? success;
  int? status;
  Meta? meta;

  factory ProductMiniResponse.fromJson(Map<String, dynamic> json) =>
      ProductMiniResponse(
        products:
            List<Product>.from(json["data"]?.map((x) => Product.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(products!.map((x) => x.toJson())),
        "meta": meta == null ? null : meta!.toJson(),
        "success": success,
        "status": status,
      };
}

class Product {
  Product({
    this.id,
    this.slug,
    this.name,
    this.thumbnail_image,
    this.main_price,
    this.stroked_price,
    this.has_discount,
    this.discount,
    this.rating,
    this.sales,
    this.shops,
    this.links,
    this.isWholesale,
  });

  int? id;
  String? slug;
  String? name;
  String? thumbnail_image;
  String? main_price;
  String? stroked_price;
  bool? has_discount;
  var discount;
  int? rating;
  int? sales;
  Shops? shops;
  Links? links;
  bool? isWholesale;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        slug: json["slug"],
        name: json["name"],
        thumbnail_image: json["thumbnail_image"],
        main_price: json["main_price"],
        stroked_price: json["stroked_price"],
        has_discount: json["has_discount"],
        discount: json["discount"],
        rating: json["rating"].toInt(),
        sales: json["sales"],
        shops: Shops.fromJson(json["shops"]),
        links: Links.fromJson(json["links"]),
        isWholesale: json["is_wholesale"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "name": name,
        "thumbnail_image": thumbnail_image,
        "main_price": main_price,
        "stroked_price": stroked_price,
        "has_discount": has_discount,
        "discount": discount,
        "rating": rating,
        "sales": sales,
        "shops": shops!.toJson(),
        "links": links!.toJson(),
        "is_wholesale": isWholesale,
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

class Links {
  Links({
    this.details,
  });

  String? details;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "details": details,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
