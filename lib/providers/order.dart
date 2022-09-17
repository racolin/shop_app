import 'package:flutter/widgets.dart';
import 'package:section__8/providers/cart.dart';
import 'dart:convert';
import '../config/api.dart';
import 'package:http/http.dart' as http;

class Orders extends ChangeNotifier {
  List<OrderItem> items = [];

  Future<void> addOrderItem(
    List<CartItem> carts,
    DateTime dateTime,
  ) async {
    String j = json.encode({
      'dateTime': dateTime.toIso8601String(),
      'carts': [
        for (CartItem item in carts)
          {
            'id': item.id,
            'productId': item.productId,
            'price': item.price,
            'title': item.title,
            'amount': item.amount,
          }
      ],
    });
    var res = await http.post(
      Uri.parse('$BASE/orders.json'),
      body: j,
    );
    if (res.statusCode <= 400) {
      fetchOrders();
    } else {
      throw Exception('Error!');
    }
  }

  Future<void> fetchOrders() async {
    var res = await http.get(Uri.parse('$BASE/orders.json'));
    if (res.statusCode <= 400) {
      var map = json.decode(res.body) as Map<String, dynamic>;
      items.clear();
      map.forEach((id, data) {
        var cs = data['carts'] as List<dynamic>;
        var carts = cs
            .map((e) => CartItem(
                  id: e['id'],
                  productId: e['productId'],
                  title: e['title'],
                  price: e['price'],
                  amount: e['amount'],
                ))
            .toList();
        items.add(OrderItem(
            id: id, carts: carts, dateTime: DateTime.parse(data['dateTime'])));
      });
      notifyListeners();
    } else {
      throw Exception('Error!');
    }
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
