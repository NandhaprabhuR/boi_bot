import 'customer.dart';

class HistoryItem {
  final Customer customer;
  final String message;
  final DateTime timestamp;

  HistoryItem({
    required this.customer,
    required this.message,
    required this.timestamp,
  });

  // Convert a HistoryItem instance to a Map
  Map<String, dynamic> toJson() => {
        'customer': customer.toJson(),
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      };

  // Create a HistoryItem instance from a Map
  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        customer: Customer.fromJson(json['customer']),
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}