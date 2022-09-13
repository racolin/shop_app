import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:section__8/providers/products.dart';

class ProductScreen extends StatelessWidget {
  static const String route = '/product_detail';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final products = Provider.of<Products>(context);
    final product = products.getProductById(id);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            product.imageUrl,
            height: 240,
            alignment: Alignment.center,
            width: double.infinity,
          ),
          Text(product.title),
          Text(NumberFormat.currency(decimalDigits: 2).format(product.price)),
        ],
      ),
    );
  }
}
