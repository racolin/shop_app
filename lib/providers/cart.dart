import 'package:flutter/widgets.dart';
import 'dart:convert';
import '../config/api.dart';
import 'package:http/http.dart' as http;

class Cart extends ChangeNotifier {
  var _token;
  set token(String token) {
    _token = token;
    notifyListeners();
  }

  var _localId;
  set localId(String localId) {
    _localId = localId;
    notifyListeners();
  }

  final List<CartItem> _items = [];

  var _loading = false;

  Future<void> addCartItem(
    String productId,
    String title,
    double price,
    int amount,
  ) async {
    if (!_loading) {
      _loading = true;
      int index =
          _items.indexWhere((element) => element.productId == productId);
      if (index != -1) {
        _items[index]
            .setAmount(_token, _localId, _items[index]._amount + amount);
        notifyListeners();
      } else {
        var res = await http.post(
            Uri.parse('$BASE/carts/$_localId.json?auth=$_token'),
            body: json.encode({
              'productId': productId,
              'title': title,
              'price': price,
              'amount': amount,
            }));
        if (res.statusCode <= 400) {
          await fetchCarts();
        } else {
          _loading = false;
          throw Exception('Error!');
        }
      }
      _loading = false;
    }
  }

  Future<void> fetchCarts() async {
    var res =
        await http.get(Uri.parse('$BASE/carts/$_localId.json?auth=$_token'));
    print('$BASE/carts.json?auth=$_token================');
    if (res.statusCode <= 400) {
      var map = json.decode(res.body) as Map<String, dynamic>?;
      _items.clear();
      if (map != null) {
        map.forEach((id, data) {
          _items.add(
            CartItem(
                id: id,
                productId: data['productId'],
                title: data['title'],
                price: data['price'],
                amount: data['amount']),
          );
        });
        notifyListeners();
      }
    } else {
      throw Exception('Load carts fail!');
    }
  }

  Future<void> fetchCart(String id) async {
    int index = _items.indexWhere((element) => element.id == id);
    if (index != -1) {
      var res = await http
          .get(Uri.parse('$BASE/carts/$_localId/$id.json?auth=$_token'));
      if (res.statusCode <= 400) {
        var map = json.decode(res.body) as Map<String, dynamic>;
        _items.clear();
        _items[index] = CartItem(
          id: id,
          productId: map['productId'],
          title: map['title'],
          price: map['price'],
        );
        notifyListeners();
      } else {
        throw Exception('Load cart fail!');
      }
    }
  }

  Future<void> clear() async {
    var res =
        await http.delete(Uri.parse('$BASE/carts/$_localId.json?auth=$_token'));
    if (res.statusCode <= 400) {
      _items.clear();
      notifyListeners();
    } else {
      throw Exception('Can\'t clear carts!');
    }
  }

  List<CartItem> get items => [..._items];

  Future<void> remove(String id) async {
    int index = _items.indexWhere((e) => e.productId == id);
    var res = await http
        .delete(Uri.parse('$BASE/carts/$_localId/$id.json?auth=$_token'));
    if (res.statusCode <= 400) {
      _items.removeAt(index);
      notifyListeners();
    } else {
      throw Exception('Error!');
    }
  }

  double calculateTotal() {
    return _items.fold(0.0, (pre, e) => pre + e.amount * e.price);
  }

  Future<void> undoItem(String id) async {
    int index = _items.indexWhere((element) => element.productId == id);
    if (index != -1) {
      int count = _items[index].amount - 1;
      if (count <= 0) {
        remove(id);
      } else {
        _items[index].setAmount(_token, _localId, count);
        notifyListeners();
      }
    }
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
    int amount = 1,
  }) : _amount = amount;

  int get amount => _amount;

  Future<void> setAmount(String token, String localId, int amount) async {
    int old = _amount;
    _amount = amount;
    var res = await http.patch(
      Uri.parse('$BASE/carts/$localId/$id.json?auth=$token'),
      body: json.encode({
        'amount': _amount,
      }),
    );
    if (res.statusCode <= 400) {
    } else {
      _amount = old;
      throw Exception('Error!');
    }
  }

  double get total => _amount * price;
}
