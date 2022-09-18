import 'package:flutter/widgets.dart';
import '../providers/product.dart';
import '../screens/overview_screen.dart';

class FilterProducts with ChangeNotifier {
  FilterType _type = FilterType.all;
  List<Product> _items = [];
  FilterProducts({
    required List<Product> items,
    FilterType type = FilterType.all,
  })  : _items = items,
        _type = type;

  set item(List<Product> i) => _items = i;

  List<Product> filterItem() {
    switch (_type) {
      case FilterType.all:
        return _items;
      case FilterType.favorite:
        return _items.where((element) => element.isFavorite == true).toList();
    }
  }

  set type(FilterType val) {
    _type = val;
    notifyListeners();
  }
}
