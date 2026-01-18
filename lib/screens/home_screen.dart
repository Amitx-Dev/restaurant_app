import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String selectedCategory = "All";
  String searchText = "";

  final PageController _pageController = PageController();
  Timer? sliderTimer;
  int currentPage = 0;

  // ================= BANNERS =================

  final List<String> banners = [
    "assets/images/banner1.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg",
  ];

  // ================= CATEGORIES =================

  final List<String> categories = [
    "All",
    "Veg",
    "Non-Veg",
    "Party",
    "Spicy"
  ];

  // ================= PRODUCTS =================

  final List<Product> products = [

    Product(
      name: "Paneer Pizza",
      price: 160,
      category: "Veg",
      image: "assets/images/products/paneer_pizza.png",
    ),

    Product(
      name: "Veg Burger",
      price: 90,
      category: "Veg",
      image: "assets/images/products/veg_burger.png",
    ),

    Product(
      name: "Chicken Burger",
      price: 140,
      category: "Non-Veg",
      image: "assets/images/products/chicken_burger.png",
    ),

    Product(
      name: "Chicken Pizza",
      price: 220,
      category: "Non-Veg",
      image: "assets/images/products/chicken_pizza.png",
    ),

    Product(
      name: "Family Combo",
      price: 499,
      category: "Party",
      image: "assets/images/products/family_combo.png",
    ),

    Product(
      name: "Birthday Pack",
      price: 799,
      category: "Party",
      image: "assets/images/products/birthday_pack.png",
    ),

    Product(
      name: "Spicy Momos",
      price: 120,
      category: "Spicy",
      image: "assets/images/products/spicy_momos.png",
    ),

    Product(
      name: "Hot Wings",
      price: 180,
      category: "Spicy",
      image: "assets/images/products/hot_wings.png",
    ),
  ];

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    startAutoSlider();
  }

  void startAutoSlider() {

    sliderTimer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) {

        if (!_pageController.hasClients) return;

        currentPage++;

        if (currentPage == banners.length) {
          currentPage = 0;
        }

        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    final filteredProducts = products.where((product) {

      final categoryMatch =
          selectedCategory == "All" ||
              product.category == selectedCategory;

      final searchMatch = product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return categoryMatch && searchMatch;

    }).toList();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Restaurant Menu"),
      ),

      body: Column(
        children: [

          // ================= SLIDER =================

          SizedBox(
            height: 190,

            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,

              onPageChanged: (index) {
                currentPage = index;
              },

              itemBuilder: (context, index) {

                return Padding(
                  padding: const EdgeInsets.all(10),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),

                    child: Stack(
                      children: [

                        // IMAGE
                        Positioned.fill(
                          child: Image.asset(
                            banners[index],
                            fit: BoxFit.cover,

                            errorBuilder:
                                (context, error, stackTrace) {

                              return Container(
                                color: Colors.orange.shade100,
                                alignment: Alignment.center,
                                child: const Text("Banner"),
                              );
                            },
                          ),
                        ),

                        // GRADIENT OVERLAY
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,

                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // TEXT OVERLAY
                        Positioned(
                          bottom: 16,
                          left: 16,

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: const [

                              Text(
                                "Today's Special",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                "Order now & get discount",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ================= SEARCH =================

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            child: TextField(
              decoration: InputDecoration(
                hintText: "Search food...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          // ================= CATEGORY =================

          SizedBox(
            height: 50,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),

              itemCount: categories.length,

              itemBuilder: (context, index) {

                final cat = categories[index];
                final selected = cat == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),

                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    selectedColor: Colors.deepOrange,

                    labelStyle: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.black,
                    ),

                    onSelected: (_) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 5),

          // ================= PRODUCT LIST =================

          Expanded(
            child: filteredProducts.isEmpty

                ? const Center(
              child: Text("No items found"),
            )

                : ListView.builder(
              itemCount: filteredProducts.length,

              itemBuilder: (context, index) {

                final item = filteredProducts[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: Padding(
                    padding: const EdgeInsets.all(10),

                    child: Row(
                      children: [

                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(12),

                          child: Image.asset(
                            item.image,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              Text(
                                item.category,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "₹ ${item.price}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          child: const Text("ADD"),

                          onPressed: () {

                            cart.addToCart(item);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content:
                                Text("${item.name} added"),
                                duration: const Duration(
                                    milliseconds: 600),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
