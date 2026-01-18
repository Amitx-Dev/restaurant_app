import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/success_dialog.dart';
import 'main_navigation_screen.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:audioplayers/audioplayers.dart';

class InvoiceScreen extends StatelessWidget {

  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: const Text("Invoice"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [

            // ================= HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(16),
              ),

              child: const Column(
                children: [

                  Text(
                    "🍽 My Restaurant",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Thank you for your order!",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ================= BILL CARD =================

            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: [

                          // ✅ MULTI TABLE FIX
                          Text(
                            "Table: ${cart.selectedTables.join(", ")}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text(
                              cart.paymentMethod,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      const Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ================= ITEM LIST =================

                      Expanded(
                        child: ListView.builder(
                          itemCount: cart.cartItems.length,

                          itemBuilder: (context, index) {

                            final item = cart.cartItems[index];

                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 6),

                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                                children: [

                                  Expanded(
                                    child: Text(
                                      "${item.name}  x${item.quantity}",
                                      style:
                                      const TextStyle(fontSize: 15),
                                    ),
                                  ),

                                  Text(
                                    "₹ ${item.price * item.quantity}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const Divider(),

                      // ================= TOTAL =================

                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children: [

                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "₹ ${cart.totalPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= BUTTONS =================

            Row(
              children: [

                // PDF BUTTON
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text("Download PDF"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),

                    onPressed: () {
                      generatePdf(cart);
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // FINISH BUTTON
                Expanded(
                  child: ElevatedButton(
                    child: const Text("Finish"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),

                    onPressed: () async {

                      // 🔊 SUCCESS SOUND
                      final player = AudioPlayer();
                      await player.play(
                        AssetSource("sounds/success.mp3"),
                      );

                      // ✅ SAVE ORDER
                      cart.saveOrder();

                      // 🎉 SHOW SUCCESS POPUP
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const SuccessDialog(),
                      );

                      // ⏳ WAIT
                      await Future.delayed(
                          const Duration(milliseconds: 1500));

                      // CLOSE DIALOG
                      Navigator.pop(context);

                      // 🔁 BACK TO MENU
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const MainNavigationScreen(),
                        ),
                            (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= PDF GENERATOR =================

  Future<void> generatePdf(CartProvider cart) async {

    final pdf = pw.Document();

    pdf.addPage(

      pw.Page(

        build: (context) {

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [

              pw.Text(
                "MY RESTAURANT",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 6),

              // ✅ MULTI TABLE FIX
              pw.Text(
                "Table No: ${cart.selectedTables.join(", ")}",
              ),

              pw.Divider(),

              pw.ListView.builder(
                itemCount: cart.cartItems.length,

                itemBuilder: (context, index) {

                  final item = cart.cartItems[index];

                  return pw.Row(
                    mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,

                    children: [

                      pw.Text("${item.name} x${item.quantity}"),

                      pw.Text(
                        "₹ ${item.price * item.quantity}",
                      ),
                    ],
                  );
                },
              ),

              pw.Divider(),

              pw.SizedBox(height: 8),

              pw.Text(
                "Total Amount: ₹ ${cart.totalPrice.toStringAsFixed(0)}",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 15),

              pw.Text("Thank You! Visit Again 😊"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
