import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

SnackBar SnackBarAlert(BuildContext context, String message) {
  return SnackBar(
    elevation: 10,
    margin: const EdgeInsets.only(right: 40, left: 40, bottom: 20),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_rounded, color: Colors.white),
        const SizedBox(width: 15),
        AutoSizeText(
          message,
          maxLines: 2,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFF8F3BB7),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    duration: const Duration(seconds: 4),
  );
}
