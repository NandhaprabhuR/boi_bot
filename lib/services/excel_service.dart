import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart'; // For BuildContext in permission checks
import '../models/customer.dart';
import 'permission_service.dart'; // Import the updated permission service

// This service handles reading customer data from an Excel file.
class ExcelService {
  final PermissionService _permissionService = PermissionService();

  // Picks an Excel file and parses its content into a list of Customer objects.
  Future<List<Customer>> importContactsFromExcel(BuildContext context) async {
    List<Customer> customers = [];
    try {
      // Check and request storage permission before picking the file
      bool storageGranted = await _permissionService.checkAndRequestStoragePermission(context);
      if (!storageGranted) {
        throw Exception('Storage permission not granted. Cannot import contacts.');
      }

      // Use file_picker to allow the user to select an Excel file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false, // Only allow single file selection
        withData: true, // Get file bytes directly
      );

      if (result == null || result.files.isEmpty || result.files.single.bytes == null) {
        print('ExcelService: No file selected or file data is null.');
        return []; // User cancelled or no data
      }

      final fileBytes = result.files.single.bytes!;
      if (fileBytes.isEmpty) {
        throw Exception('Selected Excel file is empty.');
      }

      var excel = Excel.decodeBytes(fileBytes);

      // Assuming data is in the first sheet or a sheet named 'Contacts'
      String sheetName = 'Contacts';
      if (!excel.tables.containsKey(sheetName)) {
        if (excel.tables.isNotEmpty) {
          sheetName = excel.tables.keys.first; // Fallback to the first sheet
          print('ExcelService: "Contacts" sheet not found, using first sheet: $sheetName');
        } else {
          throw Exception('No sheets found in the Excel file.');
        }
      }

      var sheet = excel.tables[sheetName];
      if (sheet == null) {
        throw Exception('Selected Excel sheet "$sheetName" is invalid.');
      }

      // Iterate over rows, skipping the header if present
      // Assume first row is header if it contains "Name" or "Mobile Number"
      int startRow = 0;
      if (sheet.rows.isNotEmpty && sheet.rows.first.length >= 2) {
        final firstCell = sheet.rows.first[0]?.value?.toString().toLowerCase();
        final secondCell = sheet.rows.first[1]?.value?.toString().toLowerCase();
        if (firstCell == 'name' || secondCell == 'mobile number' || secondCell == 'phone number') {
          startRow = 1; // Skip header row
        }
      }


      for (int i = startRow; i < sheet.rows.length; i++) {
        var row = sheet.rows[i];
        if (row.length >= 2 && row[0]?.value != null && row[1]?.value != null) {
          // Ensure the row has at least two columns and values are not null
          customers.add(Customer.fromExcelRow(row));
        } else {
          print('ExcelService: Skipping row $i due to insufficient data or null values: ${row.map((e) => e?.value).toList()}');
        }
      }
    } catch (e) {
      print('ExcelService: Error importing Excel: $e');
      // Re-throw the exception so the controller can catch and display it
      rethrow;
    }
    return customers;
  }
}