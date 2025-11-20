import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String status; 

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = 'paid',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'date': date.toIso8601String(),
        'status': status,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: (json['total'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        status: json['status'] as String,
      );
}
