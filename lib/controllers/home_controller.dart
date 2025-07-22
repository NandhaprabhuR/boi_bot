import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/customer.dart';
import '../models/history_item.dart';
import '../services/excel_service.dart';
import '../services/permission_service.dart';
import '../services/sms_service.dart';
import 'history_controller.dart';

class HomeController extends GetxController {
  final RxList<Customer> customers = <Customer>[].obs;
  final RxString messageToSend = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ExcelService _excelService = ExcelService();
  final PermissionService _permissionService = PermissionService();
  final SmsService _smsService = SmsService();
  final HistoryController _historyController = Get.find<HistoryController>();

  Future<void> importContacts(BuildContext context) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final importedCustomers = await _excelService.importContactsFromExcel(
        context,
      );
      if (importedCustomers.isNotEmpty) {
        customers.assignAll(importedCustomers);
      } else {
        errorMessage.value = 'No contacts found or file not selected.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to import contacts: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // UPDATED METHOD WITH STYLED CONFIRMATION DIALOG
  Future<void> sendSmsToAll(BuildContext context) async {
    if (customers.isEmpty || messageToSend.value.trim().isEmpty) {
      errorMessage.value = 'Please import contacts and write a message.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Pass the context to the updated permission method
      bool smsGranted = await _permissionService.requestSmsPermission(context);
      if (!smsGranted) {
        throw 'SMS permission not granted. Please grant it in settings.';
      }

      for (var customer in customers) {
        final bool shouldContinue =
            await Get.dialog(
              AlertDialog(
                // --- Style Changes Start Here ---
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: const Row(
                  children: [
                    Icon(Icons.contact_support_outlined, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Ready for Next?'),
                  ],
                ),
                titleTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                content: Text(
                  'Press "Continue" to open the SMS app for ${customer.name}.',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                // --- Style Changes End Here ---
                actions: [
                  TextButton(
                    child: const Text(
                      'Stop Process',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () => Get.back(result: false),
                  ),
                  ElevatedButton(
                    // --- Style Changes for Button ---
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    // --- End of Style Changes ---
                    child: const Text('Continue'),
                    onPressed: () => Get.back(result: true),
                  ),
                ],
              ),
              barrierDismissible: false,
            ) ??
            false;

        if (!shouldContinue) {
          Get.snackbar('Stopped', 'Bulk process stopped by user.');
          break;
        }

        await _smsService.sendSms(customer.phoneNumber, messageToSend.value);

        _historyController.addHistoryItem(
          HistoryItem(
            customer: customer,
            message: messageToSend.value,
            timestamp: DateTime.now(),
          ),
        );
      }

      Get.snackbar(
        'Complete',
        'Finished processing all contacts.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Error sending SMS: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void updateMessage(String message) {
    messageToSend.value = message;
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/customer.dart';
// import '../models/history_item.dart';
// import '../services/excel_service.dart';
// import '../services/permission_service.dart';
// import '../services/sms_service.dart';
// import 'history_controller.dart';

// class HomeController extends GetxController {
//   final RxList<Customer> customers = <Customer>[].obs;
//   final RxString messageToSend = ''.obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   final ExcelService _excelService = ExcelService();
//   final PermissionService _permissionService = PermissionService();
//   final SmsService _smsService = SmsService();
//   final HistoryController _historyController = Get.find<HistoryController>();

//   Future<void> importContacts(BuildContext context) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final importedCustomers = await _excelService.importContactsFromExcel(
//         context,
//       );
//       if (importedCustomers.isNotEmpty) {
//         customers.assignAll(importedCustomers);
//       } else {
//         errorMessage.value = 'No contacts found or file not selected.';
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to import contacts: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // UPDATED METHOD WITH STYLED CONFIRMATION DIALOG
//   Future<void> sendSmsToAll(BuildContext context) async {
//     if (customers.isEmpty || messageToSend.value.trim().isEmpty) {
//       errorMessage.value = 'Please import contacts and write a message.';
//       return;
//     }

//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       bool smsGranted = await _permissionService.requestSmsPermission();
//       if (!smsGranted) {
//         throw 'SMS permission not granted. Please grant it in settings.';
//       }

//       for (var customer in customers) {
//         final bool shouldContinue =
//             await Get.dialog(
//               AlertDialog(
//                 // --- Style Changes Start Here ---
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 title: const Row(
//                   children: [
//                     Icon(Icons.contact_support_outlined, color: Colors.black),
//                     SizedBox(width: 10),
//                     Text('Ready for Next?'),
//                   ],
//                 ),
//                 titleTextStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 content: Text(
//                   'Press "Continue" to open the SMS app for ${customer.name}.',
//                   style: const TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//                 actionsPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 // --- Style Changes End Here ---
//                 actions: [
//                   TextButton(
//                     child: const Text(
//                       'Stop Process',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     onPressed: () => Get.back(result: false),
//                   ),
//                   ElevatedButton(
//                     // --- Style Changes for Button ---
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     // --- End of Style Changes ---
//                     child: const Text('Continue'),
//                     onPressed: () => Get.back(result: true),
//                   ),
//                 ],
//               ),
//               barrierDismissible: false,
//             ) ??
//             false;

//         if (!shouldContinue) {
//           Get.snackbar('Stopped', 'Bulk process stopped by user.');
//           break;
//         }

//         await _smsService.sendSms(customer.phoneNumber, messageToSend.value);

//         _historyController.addHistoryItem(
//           HistoryItem(
//             customer: customer,
//             message: messageToSend.value,
//             timestamp: DateTime.now(),
//           ),
//         );
//       }

//       Get.snackbar(
//         'Complete',
//         'Finished processing all contacts.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       errorMessage.value = 'Error sending SMS: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void updateMessage(String message) {
//     messageToSend.value = message;
//   }
// }
