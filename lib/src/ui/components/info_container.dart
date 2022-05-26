import 'package:flutter/material.dart';

Widget infoContainer(
    BuildContext context, String showText, String label, Function onpressed) {
  return GestureDetector(
    onTap: () {
      onpressed();
    },
    child: Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              showText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
