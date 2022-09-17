import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:section__8/models/product.dart';
import 'package:section__8/providers/products.dart';
import 'package:section__8/widgets/main_drawer.dart';

class AddProductScreen extends StatefulWidget {
  static const String route = '/add_product';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlFocus = FocusNode();
  final urlController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  final _dateTime = DateTime.now();
  var product;
  bool loadding = false;
  var url = '';

  @override
  void initState() {
    product = getEmptyProduct();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    String? id = ModalRoute.of(context)?.settings.arguments as String?;
    urlController.text = "";
    if (id != null) {
      product = Provider.of<Products>(context).getProductById(id);
      urlController.text = (product as Product).imageUrl;
    }
    super.didChangeDependencies();
  }

  Product getEmptyProduct() {
    return Product(
      id: _dateTime.toString(),
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
    );
  }

  void saveForm() {
    setState(() {
      loadding = true;
    });
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    _keyForm.currentState?.save();
    print(product.id);
    var products = Provider.of<Products>(context, listen: false);
    bool contain = products.item.contains(product);
    print(contain.toString());
    if (contain) {
      products.updateProduct(product).then((_) {
        setState(() {
          loadding = false;
        });
      }).catchError((error) {
        print(error.toString());
        setState(() {
          loadding = false;
        });
      });
      setState(() {
        loadding = false;
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Edit Success!',
          ),
          action: SnackBarAction(
              label: 'OUT',
              onPressed: () {
                Navigator.of(context).pop(product);
              }),
        ),
      );
    } else {
      products.addProduct(product).then((_) {
        setState(() {
          loadding = false;
        });
      }).catchError((error) {
        print(error.toString());
        setState(() {
          loadding = false;
        });
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Add Success!',
          ),
          action: SnackBarAction(
              label: 'OUT',
              onPressed: () {
                Navigator.of(context).pop(product);
              }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      drawer: const MainDrawer(),
      body: Stack(children: [
        Form(
          key: _keyForm,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: product.title,
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'Not empty',
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // saveForm();
                    FocusScope.of(context).requestFocus(_priceFocus);
                  },
                  onSaved: (newValue) {
                    product = Product(
                      id: product.id,
                      title: newValue!,
                      description: product.description,
                      price: product.price,
                      imageUrl: product.imageUrl,
                    );
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name of product',
                  ),
                ),
                TextFormField(
                  initialValue: product.price.toString(),
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'Not empty',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_) {
                    // saveForm();
                    FocusScope.of(context).requestFocus(_descriptionFocus);
                  },
                  onSaved: (newValue) {
                    product = Product(
                      id: product.id,
                      title: product.title,
                      description: product.description,
                      price: double.parse(newValue!),
                      imageUrl: product.imageUrl,
                    );
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price of product',
                  ),
                  focusNode: _priceFocus,
                ),
                TextFormField(
                  initialValue: product.description,
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'Not empty',
                  textInputAction: TextInputAction.done,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  onFieldSubmitted: (_) {
                    // saveForm();
                    FocusScope.of(context).requestFocus(_urlFocus);
                  },
                  onSaved: (newValue) {
                    product = Product(
                      id: product.id,
                      title: product.title,
                      description: newValue!,
                      price: product.price,
                      imageUrl: product.imageUrl,
                    );
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  focusNode: _descriptionFocus,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Not empty',
                        controller: urlController,
                        focusNode: _urlFocus,
                        onSaved: (newValue) {
                          product = Product(
                            id: product.id,
                            title: product.title,
                            description: product.description,
                            price: product.price,
                            imageUrl: newValue!,
                          );
                        },
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                        ),
                      ),
                    ),
                    ClipOval(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            url = urlController.text;
                          });
                        },
                        child: const Icon(Icons.arrow_right_rounded),
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.amber),
                  child: Image.network(
                    url,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Your URL not found!');
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // _keyForm.currentState?.validate();
                    saveForm();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
        if (loadding)
          Container(
              color: Colors.black.withOpacity(0.6),
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: CircularProgressIndicator()),
      ]),
    );
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _urlFocus.dispose();
    super.dispose();
  }
}
