import 'package:flutter/widgets.dart';
import 'package:section__8/providers/cart.dart';

class Orders extends ChangeNotifier {
  List<OrderItem> items = [];

  void addOrderItem(String id, List<CartItem> carts, DateTime dateTime) {
    items.add(OrderItem(id: id, carts: carts, dateTime: dateTime));
    notifyListeners();
  }
}

class OrderItem {
  final String id;
  final List<CartItem> carts;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.carts,
    required this.dateTime,
  });

  double getTotalPrice() {
    return carts.fold(0.0, (double? pre, e) {
      return pre! + e.amount * e.price;
    });
  }
}
