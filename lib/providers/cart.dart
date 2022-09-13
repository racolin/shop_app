import 'package:flutter/widgets.dart';

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  void addCartItem(String productId, String title, double price, int amount) {
    int index = _items.indexWhere((element) => element.productId == productId);
    if (index != -1) {
      _items[index].addAmount(amount);
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
          amount: 1,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  List<CartItem> get items => [..._items];

  double calculateTotal() {
    return _items.fold(0.0, (pre, e) => pre + e.amount * e.price);
  }
}

class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  int _amount;
  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    int amount = 0,
  }) : _amount = amount;

  int get amount => _amount;

  void addAmount(int amount) {
    _amount += amount;
  }

  double get total => _amount * price;
}
