import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/excel_service.dart';
import '../services/permission_service.dart';
import '../services/sms_service.dart'; // This is now the gateway-based service

class HomeController extends GetxController {
  final RxList<Customer> customers = <Customer>[].obs;
  final RxString messageToSend = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ExcelService _excelService = ExcelService();
  final PermissionService _permissionService = PermissionService();
  final SmsService _smsService = SmsService(); // Using the new SMS service

  @override
  void onInit() {
    super.onInit();
    // Permissions for storage are still relevant for Excel import.
    // SMS permission (for native app launch) is no longer needed if using gateway exclusively.
  }

  // Imports contacts from an Excel file. (No change needed here from previous version)
  Future<void> importContacts(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final importedCustomers = await _excelService.importContactsFromExcel(context);
      if (importedCustomers.isNotEmpty) {
        customers.assignAll(importedCustomers);
        errorMessage.value = '';
        Get.snackbar(
          'Success',
          '${importedCustomers.length} contacts imported.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
        );
      } else {
        errorMessage.value = 'No contacts found or file not selected.';
        Get.snackbar(
          'Info',
          'No contacts imported or file selection cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to import contacts: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to import contacts: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sends SMS to all imported contacts using the SMS Gateway via backend.
  Future<void> sendSmsToAll() async { // No BuildContext needed here anymore for SMS
    if (customers.isEmpty) {
      errorMessage.value = 'No contacts imported yet.';
      return;
    }
    if (messageToSend.value.trim().isEmpty) {
      errorMessage.value = 'Please enter a message to send.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      // No SMS permission check needed here as we are not launching native app
      await _smsService.sendBulkSms(customers.toList(), messageToSend.value);

      errorMessage.value = 'Bulk SMS requests sent to backend successfully.';
      Get.snackbar(
        'Success',
        'SMS messages are being processed by the server.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      errorMessage.value = 'Error sending bulk SMS: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to send bulk SMS: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateMessage(String message) {
    messageToSend.value = message;
  }
}










// import 'package:get/get.dart';
// import 'package:flutter/material.dart'; // For BuildContext
// import '../models/customer.dart';
// import '../services/excel_service.dart';
// import '../services/permission_service.dart';
// import '../services/sms_service.dart';

// // HomeController manages the state and logic for the home page.
// class HomeController extends GetxController {
//   final RxList<Customer> customers = <Customer>[].obs;
//   final RxString messageToSend = ''.obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   final ExcelService _excelService = ExcelService();
//   final PermissionService _permissionService = PermissionService();
//   final SmsService _smsService = SmsService();

//   @override
//   void onInit() {
//     super.onInit();
//     // Permissions are now requested just before the action that needs them,
//     // and handled by the respective services, often with a BuildContext.
//     // Initial permission check can be done here if you want to show a warning
//     // on app start, but the current approach requests on action.
//   }

//   // Imports contacts from an Excel file.
//   Future<void> importContacts(BuildContext context) async {
//     isLoading.value = true;
//     errorMessage.value = ''; // Clear previous errors
//     try {
//       // The permission check is now handled within ExcelService.importContactsFromExcel
//       final importedCustomers = await _excelService.importContactsFromExcel(context);
//       if (importedCustomers.isNotEmpty) {
//         customers.assignAll(importedCustomers);
//         errorMessage.value = ''; // Clear any previous error on success
//         Get.snackbar(
//           'Success',
//           '${importedCustomers.length} contacts imported.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Get.theme.primaryColor,
//           colorText: Get.theme.colorScheme.onPrimary,
//         );
//       } else {
//         errorMessage.value = 'No contacts found or file not selected.';
//         Get.snackbar(
//           'Info',
//           'No contacts imported or file selection cancelled.',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.amber,
//           colorText: Colors.black,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to import contacts: ${e.toString()}';
//       Get.snackbar(
//         'Error',
//         'Failed to import contacts: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Sends SMS to all imported contacts.
//   Future<void> sendSmsToAll(BuildContext context) async {
//     if (customers.isEmpty) {
//       errorMessage.value = 'No contacts imported yet.';
//       return;
//     }
//     if (messageToSend.value.trim().isEmpty) {
//       errorMessage.value = 'Please enter a message to send.';
//       return;
//     }

//     isLoading.value = true;
//     errorMessage.value = ''; // Clear previous errors
//     try {
//       bool smsGranted = await _permissionService.requestSmsPermission(); // Request SMS permission directly here
//       if (!smsGranted) {
//         errorMessage.value = 'SMS permission not granted. Please grant it in settings.';
//         _permissionService._showPermissionDialog(context, 'SMS'); // Show dialog if denied
//         isLoading.value = false;
//         return;
//       }

//       for (var customer in customers) {
//         await _smsService.sendSms(customer.phoneNumber, messageToSend.value);
//         await Future.delayed(const Duration(milliseconds: 700));
//       }
//       errorMessage.value = 'SMS apps launched for all contacts. Please send them manually.';
//       Get.snackbar(
//         'Action Required',
//         'SMS apps launched for ${customers.length} contacts. You need to press SEND for each message.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.blueAccent,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 5),
//       );
//     } catch (e) {
//       errorMessage.value = 'Error sending SMS: ${e.toString()}';
//       Get.snackbar(
//         'Error',
//         'Failed to launch SMS app: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void updateMessage(String message) {
//     messageToSend.value = message;
//   }
// }

// extension on PermissionService {
//   void _showPermissionDialog(BuildContext context, String s) {}
// }