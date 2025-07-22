import 'package:excel/excel.dart';

class Customer {
  final String name;
  final String phoneNumber;

  Customer({required this.name, required this.phoneNumber});

  // Convert a Customer instance to a Map
  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
      };

  // Create a Customer instance from a Map
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        name: json['name'],
        phoneNumber: json['phoneNumber'],
      );

  factory Customer.fromExcelRow(List<Data?> row) {
    return Customer(
      name: row[0]?.value?.toString() ?? 'No Name',
      phoneNumber: row[1]!.value.toString().replaceAll(RegExp(r'\.0$'), ''),
    );
  }
}






