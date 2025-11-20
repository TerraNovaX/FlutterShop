import 'package:flutter/foundation.dart';
import '../../data/models/product.dart';
import '../../data/repositories/catalog_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final CatalogRepository _repository;

  ProductViewModel({CatalogRepository? repository})
      : _repository = repository ?? CatalogRepository();

  Product? _product;
  bool _isLoading = false;

  Product? get product => _product;
  bool get isLoading => _isLoading;

  Future<void> loadProduct(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await _repository.getProductById(id);
    } catch (e) {
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
