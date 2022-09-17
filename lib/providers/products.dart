import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:section__8/models/product.dart';
import 'package:section__8/screens/overview_screen.dart';
import 'dart:convert';
import '../config/api.dart';

class Products with ChangeNotifier {
  FilterType _type = FilterType.all;
  List<Product> _items = [];

  List<Product> get item => [..._items];

  FilterType get type => _type;

  Future<void> fetchProducts() async {
    var res = await http.get(Uri.parse('$BASE/products.json'));
    var map = json.decode(res.body) as Map<String, dynamic>;
    _items.clear();
    map.forEach(
      (id, data) => _items.add(
        Product(
          id: id,
          title: data['title'],
          description: data['description'],
          price: data['price'],
          imageUrl: data['imageUrl'],
          isFavorite: data['isFavorite'],
        ),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchProduct(String id) async {
    int index = _items.indexWhere((element) => id == element.id);
    if (index != -1) {
      var res = await http.get(Uri.parse('$BASE/products/$id.json'));
      var map = json.decode(res.body) as Map<String, dynamic>;
      _items[index] = Product(
        id: id,
        title: map['title'],
        description: map['description'],
        price: map['price'],
        imageUrl: map['imageUrl'],
        isFavorite: map['isFavorite'],
      );
      notifyListeners();
    }
  }

  List<Product> filterItem() {
    switch (_type) {
      case FilterType.all:
        return item;
      case FilterType.favorite:
        return item.where((element) => element.isFavorite == true).toList();
    }
  }

  set type(FilterType val) {
    _type = val;

    print(item.fold(
        "",
        (previousValue, element) =>
            "$previousValue ${element.title}--${element.isFavorite.toString()},"));
    notifyListeners();
  }

  Future<void> addOrUpdateProduct(Product product) async {
    int index = _items.indexWhere((element) => product.id == element.id);
    if (index != -1) {
      updateProduct(product);
    } else {
      await addProduct(product);
    }
    return;
  }

  Future<void> addProduct(Product value) async {
    var res = await http
        .post(Uri.parse('$BASE/products.json'),
            body: json.encode({
              'title': value.title,
              'description': value.description,
              'price': value.price,
              'imageUrl': value.imageUrl,
              'isFavorite': value.isFavorite,
            }))
        .catchError((error) {
      throw error;
    }).timeout(const Duration(seconds: 4));

    if (res.statusCode == 200) {
      _items.add(value);
      notifyListeners();
    } else {
      throw Exception('Not 200');
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((element) => product.id == element.id);
    if (index != -1) {
      var res = await http.patch(
          Uri.parse(
            '$BASE/products/${product.id}.json',
          ),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'isFavorite': product.isFavorite,
            'imageUrl': product.imageUrl,
          }));
      _items.removeAt(index);
      _items.insert(index, product);
      return fetchProduct(product.id);
    }
  }

  Future<void> remove(String id) async {
    int index = _items.indexWhere((element) => id == element.id);
    if (index != -1) {
      var product = _items.removeAt(index);
      notifyListeners();
      var res = await http.delete(Uri.parse('$BASE/products/$id.json'));
      if (res.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw Exception('Delete Fail');
      }
    }
  }

  Product? getProductById(String id) {
    int index = _items.indexWhere((element) => element.id == id);
    if (index >= 0 && index < _items.length) {
      return item.firstWhere((element) => element.id == id);
    }
    return null;
  }
}
