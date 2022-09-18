import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    var res = await http.put(
        Uri.parse('$BASE/favoriteProducts/$userId/$id.json?auth=$token'),
        body: json.encode(
          !isFavorite,
        ));
    print(res.body);
    if (res.statusCode <= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
    } else {
      throw Exception('Not change favorite!');
    }
  }

  @override
  bool operator ==(Object? other) {
    if (other is Product) {
      return other.id == id;
    }
    return false;
  }

  @override
  String toString() {
    return '$id $title $description';
  }

  @override
  int get hashCode => Object.hash(id, price);
}
