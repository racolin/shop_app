import 'package:flutter/widgets.dart';
import 'package:section__8/models/product.dart';
import 'package:section__8/widgets/product_item.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  const ProductListView({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ProductItem(),
      itemCount: products.length,
    );
  }
}
