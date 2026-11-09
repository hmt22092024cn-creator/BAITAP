import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum CustomPermissionType { location, notification, camera }

class PermissionService {
  static Future<PermissionStatus> requestPermission(CustomPermissionType type) async {
    if (kIsWeb) {
      // Web fallback mock
      return PermissionStatus.granted;
    }

    try {
      switch (type) {
        case CustomPermissionType.location:
          final status = await Permission.locationWhenInUse.request();
          return status;
        case CustomPermissionType.notification:
          final status = await Permission.notification.request();
          return status;
        case CustomPermissionType.camera:
          final status = await Permission.camera.request();
          return status;
      }
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      return PermissionStatus.granted;
    }
  }

  static Future<PermissionStatus> checkPermission(CustomPermissionType type) async {
    if (kIsWeb) return PermissionStatus.granted;
    try {
      switch (type) {
        case CustomPermissionType.location:
          return await Permission.locationWhenInUse.status;
        case CustomPermissionType.notification:
          return await Permission.notification.status;
        case CustomPermissionType.camera:
          return await Permission.camera.status;
      }
    } catch (e) {
      return PermissionStatus.denied;
    }
  }
}
