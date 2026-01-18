import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../models/order_model.dart';

class OrderHistoryScreen extends StatelessWidget {

  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final List<OrderModel> orders = cartProvider.orderHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
      ),

      body: orders.isEmpty
          ? const Center(
        child: Text(
          "No Orders Yet",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView.builder(
        itemCount: orders.length,

        itemBuilder: (context, index) {

          final order = orders[index];

          return Card(
            margin: const EdgeInsets.all(12),

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // ===== HEADER =====
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "Table: ${order.tableNo}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        "₹ ${order.total.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Payment: ${order.payment}",
                    style: const TextStyle(fontSize: 13),
                  ),

                  Text(
                    "Date: ${order.date.day}/${order.date.month}/${order.date.year}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const Divider(),

                  // ===== ORDER ITEMS =====
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: order.items.map((item) {

                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 2),

                        child: Text(
                          "• ${item.name}  x${item.quantity}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      );

                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
