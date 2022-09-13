import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:section__8/providers/order.dart';
import 'package:section__8/widgets/main_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const String route = "/order";
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<bool> isExpandList = [];
  late Orders orders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    orders = Provider.of<Orders>(context);

    isExpandList.addAll(orders.items.map((e) => false));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                isExpandList[index] = !isExpanded;
              });
            },
            children: [
              for (int i = 0; i < orders.items.length; i++)
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            NumberFormat.currency(locale: "en_US", symbol: '\$')
                                .format(
                              orders.items[i].getTotalPrice(),
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(orders.items[i].dateTime),
                          ),
                        ],
                      ),
                    );
                  },
                  body: Container(
                    padding: const EdgeInsets.all(16),
                    child: Expanded(
                      child: Column(
                        children: orders.items[i].carts
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.title),
                                    Text(
                                      '${e.amount}x ' +
                                          NumberFormat.currency(
                                                  locale: "en_US", symbol: "\$")
                                              .format(e.price),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  isExpanded: isExpandList[i],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
