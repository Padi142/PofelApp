import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

SnackBar SnackBarError(BuildContext context, String message) {
  return SnackBar(
    elevation: 10,
    margin: const EdgeInsets.only(right: 40, left: 40, bottom: 20),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.close, color: Colors.white),
        const SizedBox(width: 15),
        Expanded(
          child: AutoSizeText(
            message,
            maxLines: 30,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFFD32F2F),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    duration: const Duration(seconds: 2),
  );
}
