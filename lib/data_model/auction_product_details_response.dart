// To parse this JSON data, do
//
//     final auctionProductDeatilsResponse = auctionProductDeatilsResponseFromJson(jsonString);

import 'dart:convert';

AuctionProductDetailsResponse auctionProductDetailsResponseFromJson(
    String str) =>
    AuctionProductDetailsResponse.fromJson(json.decode(str));

String auctionProductDetailsResponseToJson(
    AuctionProductDetailsResponse data) =>
    json.encode(data.toJson());

class AuctionProductDetailsResponse {
  AuctionProductDetailsResponse({
    this.auctionProduct,
    this.success,
    this.status,
  });

  List<AuctionDetailProducts>? auctionProduct;
  bool? success;
  int? status;

  factory AuctionProductDetailsResponse.fromJson(Map<String, dynamic> json) =>
      AuctionProductDetailsResponse(
        auctionProduct: json["data"] == null
            ? []
            : List<AuctionDetailProducts>.from(
            json["data"].map((x) => AuctionDetailProducts.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "data": auctionProduct == null
        ? []
        : List<dynamic>.from(auctionProduct!.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class AuctionDetailProducts {
  AuctionDetailProducts({
    this.id,
    this.name,
    this.slug,
    this.addedBy,
    this.sellerId,
    this.shopId,
    this.shopSlug,
    this.shopName,
    this.shopLogo,
    this.photos,
    this.thumbnailImage,
    this.tags,
    this.rating,
    this.ratingCount,
    this.brand,
    this.auctionEndDate,
    this.startingBid,
    this.unit,
    this.minBidPrice,
    this.highestBid,
    this.description,
    this.videoLink,
    this.link,
  });

  int? id;
  String? name;
  String? slug;
  String? addedBy;
  int? sellerId;
  int? shopId;
  String? shopSlug;
  String? shopName;
  String? shopLogo;
  List<Photo>? photos;
  String? thumbnailImage;
  List<String>? tags;
  int? rating;
  int? ratingCount;
  Brand? brand;
  dynamic auctionEndDate;
  String? startingBid;
  String? unit;
  dynamic minBidPrice;
  dynamic highestBid;
  String? description;
  String? videoLink;
  String? link;

  factory AuctionDetailProducts.fromJson(Map<String, dynamic> json) =>
      AuctionDetailProducts(
        id: _toInt(json["id"]),
        name: json["name"],
        slug: json["slug"],
        addedBy: json["added_by"],
        sellerId: _toInt(json["seller_id"]),
        shopId: _toInt(json["shop_id"]),
        shopSlug: json["shop_slug"],
        shopName: json["shop_name"],
        shopLogo: json["shop_logo"],
        photos: json["photos"] == null
            ? []
            : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        thumbnailImage: json["thumbnail_image"],
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"].map((x) => x)),
        rating: _toInt(json["rating"]),
        ratingCount: _toInt(json["rating_count"]),
        brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
        auctionEndDate: json["auction_end_date"],
        startingBid: json["starting_bid"],
        unit: json["unit"],
        minBidPrice: json["min_bid_price"],
        highestBid: json["highest_bid"],
        description: json["description"],
        videoLink: json["video_link"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "added_by": addedBy,
    "seller_id": sellerId,
    "shop_id": shopId,
    "shop_slug": shopSlug,
    "shop_name": shopName,
    "shop_logo": shopLogo,
    "photos": photos == null
        ? []
        : List<dynamic>.from(photos!.map((x) => x.toJson())),
    "thumbnail_image": thumbnailImage,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "rating": rating,
    "rating_count": ratingCount,
    "brand": brand?.toJson(),
    "auction_end_date": auctionEndDate,
    "starting_bid": startingBid,
    "unit": unit,
    "min_bid_price": minBidPrice,
    "highest_bid": highestBid,
    "description": description,
    "video_link": videoLink,
    "link": link,
  };
}

class Brand {
  Brand({
    this.id,
    this.slug,
    this.name,
    this.logo,
  });

  int? id;
  String? slug;
  String? name;
  String? logo;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: _toInt(json["id"]),
    slug: json["slug"],
    name: json["name"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "logo": logo,
  };
}

class Photo {
  Photo({
    this.variant,
    this.path,
  });

  String? variant;
  String? path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    variant: json["variant"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "variant": variant,
    "path": path,
  };
}

// Helper function to safely convert values to int
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
