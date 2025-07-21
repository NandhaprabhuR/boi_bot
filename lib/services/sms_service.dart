// lib/services/sms_service.dart (Updated for Gateway)
import 'dart:convert'; // For JSON encoding
import 'package:http/http.dart' as http; // Import the http package
import '../models/customer.dart';

// This service will now interact with your backend server to send SMS.
class SmsService {
  // Replace with the actual URL of your backend server's SMS sending endpoint
  static const String _backendSendSmsUrl =
      'http://your-backend-server.com/send-sms'; // IMPORTANT: Replace this

  // Sends SMS to a list of contacts via your backend server.
  Future<void> sendBulkSms(List<Customer> recipients, String message) async {
    try {
      final List<Map<String, String>> contactsData = recipients
          .map(
            (customer) => {
              'name': customer.name,
              'phoneNumber': customer.phoneNumber,
            },
          )
          .toList();

      final response = await http.post(
        Uri.parse(_backendSendSmsUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // You might add an API key or token here if your backend requires it
          // 'Authorization': 'Bearer your_app_backend_token',
        },
        body: jsonEncode({'contacts': contactsData, 'message': message}),
      );

      if (response.statusCode == 200) {
        // Assuming your backend returns a success message
        print('SMS requests sent to backend successfully!');
        print('Backend response: ${response.body}');
      } else {
        // Handle errors from your backend
        print(
          'Failed to send SMS requests to backend. Status: ${response.statusCode}',
        );
        print('Backend error: ${response.body}');
        throw Exception('Failed to send SMS via backend: ${response.body}');
      }
    } catch (e) {
      print('Error sending bulk SMS via backend: $e');
      rethrow; // Re-throw to be caught by the controller
    }
  }

  // The previous sendSms method (for launching native app) is no longer needed
  // if you are fully switching to gateway. If you want both, keep it.
  // For this example, we're focusing on the gateway approach.
}

// // lib/services/sms_service.dart
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart'; // Import for debugPrint

// // This service handles launching the default SMS application.
// class SmsService {
//   // Launches the SMS app with a pre-filled recipient and message.
//   Future<void> sendSms(String phoneNumber, String message) async {
//     final String encodedMessage = Uri.encodeComponent(message);

//     final Uri smsLaunchUri = Uri(
//       scheme: 'sms',
//       path: phoneNumber,
//       queryParameters: <String, String>{
//         'body': encodedMessage,
//       },
//     );

//     debugPrint('Attempting to launch SMS URI: $smsLaunchUri'); // Log the URI

//     try {
//       // Check if the URI can be launched before attempting
//       if (await canLaunchUrl(smsLaunchUri)) {
//         debugPrint('canLaunchUrl returned TRUE for: $smsLaunchUri');
//         await launchUrl(smsLaunchUri);
//       } else {
//         debugPrint('canLaunchUrl returned FALSE for: $smsLaunchUri');
//         throw 'Could not launch SMS app for $phoneNumber. No component found to handle the URI.';
//       }
//     } catch (e) {
//       debugPrint('Error sending SMS: $e');
//       // Re-throw the exception so the controller can catch and display it
//       rethrow;
//     }
//   }
// }
