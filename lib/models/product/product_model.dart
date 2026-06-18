/// Product Model 
final class ProductModel {
  ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int?;
    title = json["title"] as String?;
    price = json["price"] as num?;
    description = json["description"] as String?;
    category = json["category"] as String?;
    image = json["image"] as String?;
    rating = json["rating"] != null
        ? Rating.fromJson(json["rating"] as Map<String, dynamic>)
        : null;
  }

  int? id;
  String? title;
  num? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["id"] = id;
    data["title"] = title;
    data["price"] = price;
    data["description"] = description;
    data["category"] = category;
    data["image"] = image;
    if (rating != null) {
      data["rating"] = rating!.toJson();
    }

    return data;
  }
}

final class Rating {
  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json["rate"] as num?;
    count = json["count"] as int?;
  }

  num? rate;
  int? count;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["rate"] = rate;
    data["count"] = count;

    return data;
  }
}
