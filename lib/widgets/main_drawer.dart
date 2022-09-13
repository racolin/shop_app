import 'package:flutter/material.dart';
import 'package:section__8/screens/order_screen.dart';
import 'package:section__8/screens/overview_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 120,
            color: Colors.purple,
            child: const Text('Welcome!'),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(OverviewScreen.route);
                  },
                  leading: const Icon(Icons.shop),
                  title: const Text('Shop'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(OrderScreen.route);
                  },
                  leading: const Icon(Icons.list_alt),
                  title: const Text('Order'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
