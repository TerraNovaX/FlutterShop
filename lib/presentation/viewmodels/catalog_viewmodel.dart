import 'package:flutter/foundation.dart';
import '../../data/models/product.dart';
import '../../data/repositories/catalog_repository.dart';

class CatalogViewModel extends ChangeNotifier {
  final CatalogRepository _repository;

  CatalogViewModel({CatalogRepository? repository})
      : _repository = repository ?? CatalogRepository();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _repository.getProducts();
      _applyFilter();
    } catch (e) {
      _allProducts = [];
      _filteredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lower = _searchQuery.toLowerCase();
      _filteredProducts = _allProducts.where((p) {
        return p.title.toLowerCase().contains(lower) ||
            p.category.toLowerCase().contains(lower);
      }).toList();
    }
  }
}
