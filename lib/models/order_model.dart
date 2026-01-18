import 'product_model.dart';

class OrderModel {

  final List<Product> items;
  final String tableNo; // MULTI TABLE STRING
  final String payment;
  final double total;
  final DateTime date;

  OrderModel({
    required this.items,
    required this.tableNo,
    required this.payment,
    required this.total,
    required this.date,
  });
}
