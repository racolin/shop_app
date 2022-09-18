import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/add_product_screen.dart';
import '../widgets/main_drawer.dart';

class ManageScreen extends StatelessWidget {
  static const String route = '/manage';
  const ManageScreen({Key? key}) : super(key: key);

  void toAddScreen(
    BuildContext context, {
    String? id,
  }) {
    Navigator.of(context).pushNamed(AddProductScreen.route, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              toAddScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchProducts(true),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return Provider.of<Products>(context, listen: false)
                      .fetchProducts(true);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Consumer<Products>(
                        builder: (context, products, child) {
                          return ListView.builder(
                            itemCount: products.item.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: ClipOval(
                                  child: Image.network(
                                    fit: BoxFit.contain,
                                    products.item[index].imageUrl,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                title: Text(products.item[index].title),
                                trailing: SizedBox(
                                  width: 120,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          toAddScreen(
                                            context,
                                            id: products.item[index].id,
                                          );
                                        },
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          products
                                              .remove(products.item[index].id)
                                              .then(
                                            (_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Delete Success!')));
                                            },
                                          ).catchError(
                                            (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Delete Fail!')));
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
