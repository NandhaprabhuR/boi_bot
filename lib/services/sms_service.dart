

// lib/services/sms_service.dart
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart'; // Import for debugPrint

// This service handles launching the default SMS application.
class SmsService {
  // Launches the SMS app with a pre-filled recipient and message.
  Future<void> sendSms(String phoneNumber, String message) async {
    final String encodedMessage = Uri.encodeComponent(message);

    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': encodedMessage,
      },
    );

    debugPrint('Attempting to launch SMS URI: $smsLaunchUri'); // Log the URI

    try {
      // Check if the URI can be launched before attempting
      if (await canLaunchUrl(smsLaunchUri)) {
        debugPrint('canLaunchUrl returned TRUE for: $smsLaunchUri');
        await launchUrl(smsLaunchUri);
      } else {
        debugPrint('canLaunchUrl returned FALSE for: $smsLaunchUri');
        throw 'Could not launch SMS app for $phoneNumber. No component found to handle the URI.';
      }
    } catch (e) {
      debugPrint('Error sending SMS: $e');
      // Re-throw the exception so the controller can catch and display it
      rethrow;
    }
  }
}
