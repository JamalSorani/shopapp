// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_list.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';

var _isInit = true;

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  final String userId;

  const ProductsOverviewScreen({super.key, required this.userId});
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var isLoading = false;

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });

      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          isLoading = false;
          _isInit = false;
        });
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Do you want to leave?',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: color),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: color),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          backgroundColor: color,
          title: const Text('MyShop'),
          actions: [
            IconButton(
              icon: const Icon(Icons.color_lens_outlined),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Change another color'),
                    content: MaterialColorPicker(
                      onColorChange: (value) {
                        color = value;
                      },
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: color),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: color),
                        onPressed: () {
                          setState(() {
                            color;
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Badge(
                  label: Text(cart.itemCount.toString()),
                  child: ch,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.Favorites,
                  child: Text('Only Favorites'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.All,
                  child: Text('Show All'),
                ),
              ],
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : RefreshIndicator(
                color: color,
                onRefresh: () => _refresh(context),
                child: ProductsList(_showOnlyFavorites),
              ),
      ),
    );
  }
}
