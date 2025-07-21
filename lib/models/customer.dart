// lib/models/customer.dart
// This model represents a single contact with a name and phone number.
class Customer {
  final String name;
  final String phoneNumber;

  Customer({required this.name, required this.phoneNumber});

  // Factory constructor to create a Customer from a list of dynamic values (e.g., from Excel row)
  factory Customer.fromExcelRow(List<dynamic> row) {
    // Assuming the first column is name and the second is phone number
    // Handle potential nulls or incorrect types by converting to String
    return Customer(
      name: row.isNotEmpty && row[0]?.value != null
          ? row[0]!.value.toString()
          : 'Unknown Name',
      phoneNumber: row.length > 1 && row[1]?.value != null
          ? row[1]!.value.toString()
          : 'Unknown Number',
    );
  }
}
