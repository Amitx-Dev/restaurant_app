import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'invoice_screen.dart';

class PaymentScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // CASH PAYMENT
            Card(
              child: ListTile(
                leading: const Icon(Icons.money),
                title: const Text("Cash Payment"),
                trailing: const Icon(Icons.arrow_forward),

                onTap: () {
                  cart.setPayment("Cash");

                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => InvoiceScreen()));
                },
              ),
            ),

            // QR PAYMENT
            Card(
              child: ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text("UPI QR Payment"),
                trailing: const Icon(Icons.arrow_forward),

                onTap: () {

                  showDialog(
                    context: context,
                    builder: (_) => QRDialog(cart: cart),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= QR POPUP =================

class QRDialog extends StatelessWidget {

  final CartProvider cart;

  const QRDialog({required this.cart});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text("Scan & Pay"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Image.asset(
            "assets/images/upi_qr.png",
            height: 220,
          ),

          const SizedBox(height: 10),

          Text(
            "Amount: ₹ ${cart.totalPrice}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      actions: [

        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        ElevatedButton(
          child: const Text("Payment Done"),

          onPressed: () {

            cart.setPayment("UPI QR");

            Navigator.pop(context);

            Navigator.push(context,
                MaterialPageRoute(builder: (_) => InvoiceScreen()));
          },
        ),
      ],
    );
  }
}
