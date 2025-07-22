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

    debugPrint('Attempting to launch SMS URI: $smsLaunchUri');

    try {
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        throw 'Could not launch SMS app for $phoneNumber.';
      }
    } catch (e) {
      debugPrint('Error launching SMS app: $e');
      rethrow;
    }
  }
}