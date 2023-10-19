import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/main.dart';
import 'package:shopapp/providers/product.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String userId;
  const UserProductItem(this.id, this.title, this.imageUrl, this.userId,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Product newProduct =
        Provider.of<Products>(context, listen: false).findById(id);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: <Widget>[
            !newProduct.isVisible && userId == adminId
                ? IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .updateProduct(
                          id,
                          Product(
                            id: id,
                            title: title,
                            description: newProduct.description,
                            price: newProduct.price,
                            imageUrl: imageUrl,
                            creatorId: newProduct.creatorId,
                            isVisible: true,
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Deleting failed!',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    color: const Color.fromARGB(255, 56, 142, 60),
                  )
                : const SizedBox(width: 50),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: const Color.fromARGB(255, 25, 118, 210),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: const Color.fromARGB(255, 211, 47, 47),
            ),
          ],
        ),
      ),
    );
  }
}
