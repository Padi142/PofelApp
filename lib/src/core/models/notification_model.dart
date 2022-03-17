import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.message,
    required this.sentByName,
    required this.sentByProfilePic,
    required this.id,
    required this.sentOn,
    required this.type,
    required this.pofelId,
    required this.userId,
    required this.shown,
  });

  final String message;
  final String sentByName;
  final String sentByProfilePic;
  final String id;
  final NotificationType type;
  final DateTime sentOn;
  final bool shown;

  final String pofelId;
  final String userId;

  @override
  List<Object?> get props => [];

  static NotificationModel notificationFromMap(
    QueryDocumentSnapshot<Object?> map,
  ) {
    return NotificationModel(
      message: map["message"],
      sentByName: map["sentByName"],
      sentByProfilePic: map["sentByProfilePic"],
      id: map["id"],
      userId: map["userId"],
      pofelId: map["pofelId"],
      shown: map["shown"],
      type: getNotTypeFromText(map["type"]),
      sentOn: map["sentOn"].toDate(),
    );
  }

  static NotificationType getNotTypeFromText(String type) {
    switch (type) {
      case "INVITE":
        return NotificationType.INIVTE;
      case "FOLLOW":
        return NotificationType.FOLLOW;
      case "MESSAGE":
        return NotificationType.MESSAGE;
      default:
        return NotificationType.NONE;
    }
  }

  String getTextFromNotType(NotificationType type) {
    switch (type) {
      case NotificationType.INIVTE:
        return "INVITE";
      case NotificationType.FOLLOW:
        return "FOLLOW";
      case NotificationType.MESSAGE:
        return "MESSAGE";
      default:
        return "NONE";
    }
  }
}

enum NotificationType { INIVTE, FOLLOW, MESSAGE, NONE }
