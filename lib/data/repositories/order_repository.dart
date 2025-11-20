import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';

class OrderRepository {
  static const _ordersKey = 'orders';

  Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ordersKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(orders.map((e) => e.toJson()).toList());
    await prefs.setString(_ordersKey, jsonString);
  }

  Future<void> addOrder(Order order) async {
    final orders = await loadOrders();
    orders.add(order);
    await _saveOrders(orders);
  }
}
