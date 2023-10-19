import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/main.dart';
import 'package:shopapp/screens/create_product_screen.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  final String userId;

  const UserProductsScreen({super.key, required this.userId});
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
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
        appBar: AppBar(
          backgroundColor: color,
          title: const Text('The Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(CreateProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _refresh(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(
                        color: color,
                      ),
                    )
                  : RefreshIndicator(
                      color: color,
                      onRefresh: () => _refresh(context),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, child) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, i) =>
                                productsData.items[i].creatorId == userId ||
                                        userId == adminId
                                    ? Column(
                                        children: [
                                          UserProductItem(
                                            productsData.items[i].id,
                                            productsData.items[i].title,
                                            productsData.items[i].imageUrl,
                                            userId,
                                          ),
                                          const Divider(),
                                        ],
                                      )
                                    : const SizedBox(height: 0, width: 0),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
