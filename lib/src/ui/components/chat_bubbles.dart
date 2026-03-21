import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/models/message_model.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';

Widget myChat(BuildContext context, MessageModel message) {
  return InkWell(
      borderRadius: BorderRadius.circular(24),
      onLongPress: () {
        Clipboard.setData(ClipboardData(
          text: message.message,
        ));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBarAlert(context, 'Zkopírováno'));
      },
      highlightColor: Colors.transparent,
      child: Ink(
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: PofelPalette.buttonGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatMessageTime(message.sentOn),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ChatAvatar(imageUrl: message.sentByProfilePic),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
}

Widget otherChat(BuildContext context, MessageModel message) {
  return InkWell(
      borderRadius: BorderRadius.circular(24),
      onLongPress: () {
        Clipboard.setData(ClipboardData(
          text: message.message,
        ));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBarAlert(context, 'Zkopírováno'));
      },
      highlightColor: Colors.transparent,
      child: Ink(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.76,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: PofelPalette.softLilac.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ChatAvatar(imageUrl: message.sentByProfilePic),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        message.sentByName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PofelPalette.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  message.message,
                  style: const TextStyle(
                    color: PofelPalette.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _formatMessageTime(message.sentOn),
                  style: TextStyle(
                    color: PofelPalette.text.withValues(alpha: 0.55),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 13,
      foregroundImage: NetworkImage(imageUrl),
      onForegroundImageError: (_, __) {},
      backgroundColor: Colors.white.withValues(alpha: 0.85),
      child: const Icon(
        Icons.person_rounded,
        size: 15,
        color: PofelPalette.primary,
      ),
    );
  }
}

String _formatMessageTime(DateTime value) {
  return DateFormat('HH:mm').format(value);
}
