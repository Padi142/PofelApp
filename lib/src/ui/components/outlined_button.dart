import 'package:flutter/material.dart';

Widget outlinedButton(
    BuildContext context, String label, IconData icon, Function onpressed) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 20,
      right: 20,
      top: 8,
    ),
    child: OutlinedButton(
      onPressed: () {
        onpressed();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Icon(icon, color: Colors.white)),
            Expanded(
              flex: 3,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        side: const BorderSide(
          width: 3,
          color: Color(0xFFFFFFFF),
        ),
      ),
    ),
  );
}
