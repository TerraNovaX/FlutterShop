import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';
import 'cart_viewmodel.dart';

class CheckoutViewModel extends ChangeNotifier {
  final OrderRepository _repository;
  bool isProcessing = false;
  String? error;

  CheckoutViewModel(this._repository);

  Future<bool> checkout(CartViewModel cart) async {
    if (cart.items.isEmpty) {
      error = 'Votre panier est vide';
      notifyListeners();
      return false;
    }

    isProcessing = true;
    error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final order = Order(
        id: const Uuid().v4(),
        items: List.from(cart.items),
        total: cart.total,
        date: DateTime.now(),
        status: 'paid',
      );

      await _repository.addOrder(order);
      cart.clear();

      isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      isProcessing = false;
      error = 'Erreur lors de la création de la commande';
      notifyListeners();
      return false;
    }
  }
}
