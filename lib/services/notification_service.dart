import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class NotificationService {
  static Future<void> init() async {
    if (kIsWeb) {
      // Meminta izin notifikasi browser dari user
      if (web.Notification.permission != 'granted') {
        web.Notification.requestPermission();
      }
    }
  }

  static Future<void> scheduleDeadlineReminder({
    required int id,
    required String title,
    required DateTime deadline,
    required int reminderDaysBefore,
  }) async {
    final reminderDate = deadline.subtract(Duration(days: reminderDaysBefore));
    final now = DateTime.now();

    if (reminderDate.isAfter(now)) {
      final difference = reminderDate.difference(now);

      Timer(difference, () {
        _showWebNotification(
          'Pengingat Target: $title',
          'Target ini mendekati batas waktu pada ${deadline.day}/${deadline.month}/${deadline.year}!',
        );
      });
    } else if (now.isAfter(reminderDate) && now.isBefore(deadline)) {
      _showWebNotification(
        'Pengingat Target: $title',
        'Target ini mendekati batas waktu pada ${deadline.day}/${deadline.month}/${deadline.year}!',
      );
    }
  }

  static void _showWebNotification(String title, String body) {
    if (kIsWeb && web.Notification.permission == 'granted') {
      web.Notification(title, web.NotificationOptions(body: body));
    }
  }
}
