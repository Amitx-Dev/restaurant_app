import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';

class MainNavigationScreen extends StatefulWidget {

  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    CartScreen(),
    OrderHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: selectedIndex,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,

        items: [

          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Menu",
          ),

          // 🛒 CART WITH BADGE ANIMATION
          BottomNavigationBarItem(
            label: "Cart",

            icon: Stack(
              clipBehavior: Clip.none,

              children: [

                const Icon(Icons.shopping_cart),

                if (cart.totalItems > 0)
                  Positioned(
                    right: -6,
                    top: -6,

                    child: AnimatedSwitcher(
                      duration:
                      const Duration(milliseconds: 300),

                      transitionBuilder:
                          (child, animation) {

                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },

                      child: Container(
                        key:
                        ValueKey(cart.totalItems),

                        padding:
                        const EdgeInsets.all(6),

                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),

                        child: Text(
                          cart.totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
      ),
    );
  }
}
