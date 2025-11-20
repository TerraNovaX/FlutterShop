import '../models/product.dart';
import '../services/api_service.dart';

class CatalogRepository {
  final ApiService apiService;

  CatalogRepository({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  Future<List<Product>> getProducts() {
    return apiService.fetchProducts();
  }

  Future<Product> getProductById(int id) {
    return apiService.fetchProductById(id);
  }
}
