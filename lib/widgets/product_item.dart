import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/auth.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: product.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        height: 190.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 166.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 30),
                height: 200.0,
                width: 200.0,
                child: Column(
                  children: [
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.fill,
                      height: 140,
                      width: 200,
                      //               ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Consumer<Product>(
                          builder: (ctx, product, _) => IconButton(
                            icon: Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            color: color,
                            onPressed: () {
                              product.toggleFavoriteStatus(
                                  authData.token!, authData.userId);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                          ),
                          onPressed: () {
                            cart.addItem(
                                product.id, product.price, product.title);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Added to cart...'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                    textColor: color,
                                    label: 'undo',
                                    onPressed: () {
                                      cart.removeSingleItem(product.id);
                                    }),
                              ),
                            );
                          },
                          color: color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: SizedBox(
                height: 136.0,
                width: MediaQuery.of(context).size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        product.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 5 / 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFfcca46),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(' \$${product.price}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
