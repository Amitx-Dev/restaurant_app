import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart';

class TableScreen extends StatelessWidget {

  final List<int> tables =
  List.generate(10, (index) => index + 1);

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Select Tables (Max 2)")),

      body: Column(
        children: [

          const SizedBox(height: 10),

          Text(
            "Selected: ${cart.selectedTables.join(", ")}",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),

              itemCount: tables.length,

              itemBuilder: (context, index) {

                final table = tables[index];
                final selected =
                cart.selectedTables.contains(table);

                return GestureDetector(
                  onTap: () {
                    cart.toggleTable(table);
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    child: Center(
                      child: Text(
                        "Table $table",
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                child: const Text("Proceed To Payment"),

                onPressed: cart.selectedTables.isEmpty
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
