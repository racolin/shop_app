import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section__8/providers/cart.dart';
import 'package:section__8/providers/products.dart';
import 'package:section__8/screens/cart_screen.dart';
import 'package:section__8/widgets/main_drawer.dart';
import 'package:section__8/widgets/product_grid_view.dart';

enum FilterType { all, favorite }

class OverviewScreen extends StatefulWidget {
  static const String route = '/overview';
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool _initted = false;
  bool _loading = false;
  late Cart c;

  @override
  void initState() {
    c = Provider.of<Cart>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (!_initted) {
      _loading = true;
      await Provider.of<Products>(context, listen: false).fetchProducts();
      await c.fetchCarts();
      _loading = false;
    }
    _initted = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  products.type = FilterType.all;
                },
                value: FilterType.all,
                child: const Text('Show all'),
              ),
              PopupMenuItem(
                onTap: () {
                  products.type = FilterType.favorite;
                },
                value: FilterType.favorite,
                child: const Text('Show favorite'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
              position: const BadgePosition(top: 4, end: 4),
              badgeContent: Text(
                cart.items.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.route);
                },
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          const ProductGridView(),
          if (_loading)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.7),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {}), child: const Icon(Icons.add)),
    );
  }
}
