/// Enum for product filters
enum ProductFilters {
  nameAToZ("Name: A To Z"),
  nameZToA("Name: Z To A"),

  priceLowToHigh("Price: Low To High"),
  priceHighToLow("Price: High To low"),

  ratingLowToHigh("Rating: Low To High"),
  ratingHighToLow("Rating: high To low");

  const ProductFilters(this.value);

  final String value;

  String get title {
    return value;
  }
}
