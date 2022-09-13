import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:section__8/models/product.dart';
import 'package:section__8/providers/products.dart';
import 'package:section__8/screens/overview_screen.dart';
import 'package:section__8/widgets/product_item.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<Products>(context);
    final List<Product> products = productsData.filterItem();
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider<Product>.value(
        value: products[index],
        child: ProductItem(
          key: ValueKey(products[index].id),
        ),
      ),
      itemCount: products.length,
    );
  }
}
