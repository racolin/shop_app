import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section__8/providers/cart.dart';
import 'package:section__8/screens/product_screen.dart';

import '../models/product.dart';

class ProductItem extends StatefulWidget {
  // final Product product;
  const ProductItem({
    Key? key,
    // required this.product
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var adding = false;
  var product;
  var cart;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = Provider.of<Product>(context, listen: false);
    cart = Provider.of<Cart>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        // header: GridTileBar(
        //   title: Text(product.title),
        // ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, value, child) => IconButton(
              onPressed: () {
                product.toggleFavorite().then((_) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Change favorite success!'),
                  ));
                }).catchError((e) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Change favorite fail!'),
                  ));
                });
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: adding
                ? null
                : () {
                    setState(() {
                      adding = true;
                    });
                    cart
                        .addCartItem(
                            product.id, product.title, product.price, 1)
                        .then((value) {
                      setState(() {
                        adding = false;
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Added success!'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                cart.undoItem(product.id);
                              },
                            ),
                          ),
                        );
                      });
                    });
                  },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.title,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductScreen.route, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
