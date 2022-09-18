import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section__8/providers/auth.dart';
import 'package:section__8/providers/cart.dart';
import 'package:section__8/providers/order.dart';
import 'package:section__8/providers/products.dart';
import 'package:section__8/screens/auth_screen.dart';
import 'package:section__8/screens/cart_screen.dart';
import 'package:section__8/screens/add_product_screen.dart';
import 'package:section__8/screens/manage_screen.dart';
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
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (_, auth, products) {
            if (products != null) {
              products.token = auth.token;
              products.localId = auth.localId;
              return products;
            }
            return Products();
          },
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (context) => Cart(),
          update: (_, auth, cart) {
            if (cart != null) {
              cart.token = auth.token;
              cart.localId = auth.localId;
              return cart;
            }
            return Cart();
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (_, auth, orders) {
            if (orders != null) {
              orders.token = auth.token;
              orders.localId = auth.localId;
              return orders;
            }
            return Orders();
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          print('==============================${auth.isAuth}');
          Widget a = auth.isAuth ? const OverviewScreen() : const AuthScreen();
          return MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
                fontFamily: 'Lato'),
            home: a,
            routes: {
              OverviewScreen.route: (_) => const OverviewScreen(),
              ProductScreen.route: (_) => const ProductScreen(),
              CartScreen.route: (_) => const CartScreen(),
              OrderScreen.route: (_) => const OrderScreen(),
              ManageScreen.route: (_) => const ManageScreen(),
              AddProductScreen.route: (_) => const AddProductScreen(),
              AuthScreen.route: (_) => const AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
