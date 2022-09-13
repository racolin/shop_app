import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section__8/providers/cart.dart';
import 'package:section__8/providers/order.dart';
import 'package:section__8/providers/products.dart';
import 'package:section__8/screens/cart_screen.dart';
import 'package:section__8/screens/order_screen.dart';
import 'package:section__8/screens/overview_screen.dart';
import 'package:section__8/screens/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato'),
          routes: {
            '/': (_) => const OverviewScreen(),
            OverviewScreen.route: (_) => const OverviewScreen(),
            ProductScreen.route: (_) => const ProductScreen(),
            CartScreen.route: (_) => const CartScreen(),
            OrderScreen.route: (_) => const OrderScreen(),
          },
        );
      },
    );
  }
}
