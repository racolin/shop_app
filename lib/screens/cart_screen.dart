import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const String route = "/cart";

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final Orders orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.purple),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: Text(
                            NumberFormat.currency(locale: "en_US", symbol: "\$")
                                .format(cart.calculateTotal()),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (cart.calculateTotal() > 0) {
                              orders
                                  .addOrderItem(
                                cart.items,
                                DateTime.now(),
                              )
                                  .then((value) {
                                cart.clear();
                              });
                            }
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: const Text(
                            'ORDER NOW',
                            style: TextStyle(color: Colors.purple),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            actions: [
                              ElevatedButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            ],
                            title: const Text(
                              'Confirm',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                                'Are you sure to remove this item cart?'),
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      cart.remove(cart.items[index].id);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete),
                    ),
                    key: ValueKey(cart.items[index].id),
                    child: Card(
                      child: ListTile(
                        title: Text(cart.items[index].title),
                        subtitle: Text(
                          NumberFormat.currency(locale: "en_US").format(
                              cart.items[index].amount *
                                  cart.items[index].price),
                        ),
                        trailing: Text("x${cart.items[index].amount}"),
                        leading: ClipOval(
                          child: Container(
                              height: 48,
                              width: 48,
                              padding: const EdgeInsets.all(4),
                              alignment: Alignment.center,
                              color: Colors.purple,
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                child: Text(
                                  NumberFormat.currency(
                                          locale: "en_US", symbol: "\$")
                                      .format(
                                    cart.items[index].amount *
                                        cart.items[index].price,
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: cart.items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
