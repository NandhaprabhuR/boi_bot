import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Import for DeviceInfoPlugin

// This service handles requesting and checking necessary permissions.
class PermissionService {
  // Checks and requests necessary storage permission based on Android SDK version.
  Future<bool> checkAndRequestStoragePermission(BuildContext context) async {
    if (!Platform.isAndroid) return true; // Permissions not strictly required for non-Android

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt ?? 0;


    if (sdkInt >= 33) {

      return true;
    }

    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            await _showPermissionDialog(context, 'Storage');
          }
          return false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('PermissionService.checkAndRequestStoragePermission: Error: $e');
      return false;
    }
  }

  // UPDATED METHOD
  // Requests SMS permission and handles permanent denial.
  Future<bool> requestSmsPermission(BuildContext context) async {
    var status = await Permission.sms.status;
    if (status.isGranted) {
      return true; // Already granted
    }

    // If denied, request it.
    status = await Permission.sms.request();

    if (status.isGranted) {
      return true;
    }

    // If it's still not granted, check if it was permanently denied.
    if (status.isPermanentlyDenied) {
      // Show the helper dialog to guide the user to settings.
      await _showPermissionDialog(context, 'SMS');
    }

    return false; // Return false if permission is not granted.
  }


  // Checks if SMS permission is granted.
  Future<bool> checkSmsPermission() async {
    return await Permission.sms.isGranted;
  }

  // Helper to show a dialog for permanently denied permissions
  Future<void> _showPermissionDialog(BuildContext context, String permissionType) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(
          'This app needs $permissionType permission to function correctly. Please grant it in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings(); // Opens app settings for the user to grant permission
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

}






// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart'; // Import for DeviceInfoPlugin

// // This service handles requesting and checking necessary permissions.
// class PermissionService {
//   // Checks and requests necessary storage permission based on Android SDK version.
//   Future<bool> checkAndRequestStoragePermission(BuildContext context) async {
//     if (!Platform.isAndroid) return true; // Permissions not strictly required for non-Android

//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//     final sdkInt = androidInfo.version.sdkInt ?? 0;


//     if (sdkInt >= 33) {

//       return true;
//     }

//     try {
//       var status = await Permission.storage.status;
//       if (!status.isGranted) {
//         status = await Permission.storage.request();
//         if (!status.isGranted) {
//           if (status.isPermanentlyDenied) {
//             await _showPermissionDialog(context, 'Storage');
//           }
//           return false;
//         }
//       }
//       return true;
//     } catch (e) {
//       debugPrint('PermissionService.checkAndRequestStoragePermission: Error: $e');
//       return false;
//     }
//   }

//   // Requests SMS permission.
//   Future<bool> requestSmsPermission() async {
//     var status = await Permission.sms.status;
//     if (status.isDenied) {
//       status = await Permission.sms.request();
//     }
//     return status.isGranted;
//   }

//   // Checks if SMS permission is granted.
//   Future<bool> checkSmsPermission() async {
//     return await Permission.sms.isGranted;
//   }

//   // Helper to show a dialog for permanently denied permissions
//   Future<void> _showPermissionDialog(BuildContext context, String permissionType) async {
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Permission Required'),
//         content: Text(
//           'This app needs $permissionType permission to function correctly. Please grant it in settings.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await openAppSettings(); // Opens app settings for the user to grant permission
//             },
//             child: const Text('Open Settings'),
//           ),
//         ],
//       ),
//     );
//   }

// }