import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void _showCustomSnackbar({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.rawSnackbar(
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 96),
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      duration: const Duration(seconds: 2),
      boxShadows: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        )
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInCirc,
    );
  }

  static void showError(String title, String message) {
    _showCustomSnackbar(
      title: title,
      message: message,
      color: const Color(0xFFEF4444), // Modern soft red
      icon: Icons.close,
    );
  }

  static void showSuccess(String title, String message) {
    _showCustomSnackbar(
      title: title,
      message: message,
      color: const Color(0xFF10B981), // Modern premium green
      icon: Icons.check,
    );
  }

  static void showInfo(String title, String message) {
    _showCustomSnackbar(
      title: title,
      message: message,
      color: const Color(0xFFEF4444), // Destructive/warning red for removed items
      icon: Icons.delete_outline,
    );
  }
}
