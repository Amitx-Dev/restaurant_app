import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class CartProvider extends ChangeNotifier {

  List<Product> cartItems = [];

  // ✅ MULTI TABLE SUPPORT
  List<int> selectedTables = [];

  // ORDER HISTORY
  List<OrderModel> orderHistory = [];

  String paymentMethod = "";

  // ---------------- ADD PRODUCT ----------------

  void addToCart(Product product) {

    int index =
    cartItems.indexWhere((item) => item.name == product.name);

    if (index >= 0) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(Product(
        name: product.name,
        price: product.price,
        category: product.category,
        image: product.image,
        quantity: 1,
      ));
    }

    notifyListeners();
  }

  // ---------------- QTY ----------------

  void increaseQty(Product product) {
    product.quantity++;
    notifyListeners();
  }

  void decreaseQty(Product product) {

    if (product.quantity > 1) {
      product.quantity--;
    } else {
      cartItems.remove(product);
    }

    notifyListeners();
  }

  // ---------------- TABLE SELECT ----------------

  void toggleTable(int tableNo) {

    if (selectedTables.contains(tableNo)) {
      selectedTables.remove(tableNo);
    } else {
      if (selectedTables.length < 2) {
        selectedTables.add(tableNo);
      }
    }

    notifyListeners();
  }

  void clearTables() {
    selectedTables.clear();
    notifyListeners();
  }

  // ---------------- PAYMENT ----------------

  void setPayment(String method) {
    paymentMethod = method;
    notifyListeners();
  }

  // ---------------- TOTAL ----------------

  double get totalPrice {

    double total = 0;

    for (var item in cartItems) {
      total += item.price * item.quantity;
    }

    return total;
  }

  // ---------------- CART BADGE ----------------

  int get totalItems {

    int count = 0;

    for (var item in cartItems) {
      count += item.quantity;
    }

    return count;
  }

  // ---------------- SAVE ORDER ----------------

  void saveOrder() {

    if (cartItems.isEmpty) return;

    orderHistory.insert(
      0,
      OrderModel(
        items: List.from(cartItems),
        tableNo: selectedTables.join(", "),
        payment: paymentMethod,
        total: totalPrice,
        date: DateTime.now(),
      ),
    );

    clearCart();
  }

  // ---------------- CLEAR ----------------

  void clearCart() {

    cartItems.clear();
    selectedTables.clear();
    paymentMethod = "";

    notifyListeners();
  }
}
