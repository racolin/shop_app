import 'package:flutter/widgets.dart';
import '../providers/product.dart';
import '../widgets/product_item.dart';

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
