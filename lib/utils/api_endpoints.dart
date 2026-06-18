/// API endpoints
final class APIEndpoints {
  /// Ping server
  String pingServer() {
    return "https://www.google.com/generate_204";
  }

  /// Base URL
  String baseUrl() {
    return "https://fakestoreapi.com";
  }

  /// Products endpoint
  String products() {
    return "${baseUrl()}/products";
  }

  /// Product details endpoint
  String productDetails(int id) {
    return "${products()}/$id";
  }
}
