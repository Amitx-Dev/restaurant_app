import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'table_screen.dart';

class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),

      body: Column(
        children: [

          // CART ITEMS
          Expanded(
            child: cart.cartItems.isEmpty
                ? const Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: cart.cartItems.length,

              itemBuilder: (context, index) {

                final item = cart.cartItems[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text(item.name),

                    subtitle: Text(
                        "₹ ${item.price} x ${item.quantity}"),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        // MINUS BUTTON
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () {
                            cart.decreaseQty(item);
                          },
                        ),

                        Text(
                          item.quantity.toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),

                        // PLUS BUTTON
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: () {
                            cart.increaseQty(item);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // BOTTOM TOTAL BAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),

            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Total",
                      style: TextStyle(fontSize: 18),
                    ),

                    Text(
                      "₹ ${cart.totalPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 48,

                  child: ElevatedButton(
                    child: const Text("Proceed To Table"),

                    onPressed: () {

                      if (cart.cartItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cart is empty"),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TableScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
