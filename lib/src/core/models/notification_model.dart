import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';

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
  List<Object?> get props => [
        message,
        sentByName,
        sentByProfilePic,
        id,
        type,
        sentOn,
        shown,
        pofelId,
        userId,
      ];

  static NotificationModel notificationFromMap(
    Map<String, dynamic> map,
  ) {
    return NotificationModel(
      message: map["message"],
      sentByName: map["sentByName"],
      sentByProfilePic: map["sentByProfilePic"],
      id: map["id"] ?? map[r'$id'],
      userId: map["userId"],
      pofelId: (map["pofelId"] ?? '').toString(),
      shown: parseBool(map["shown"]),
      type: NotificationType.fromText((map["type"] ?? '').toString()),
      sentOn: parseDateTime(map["sentOn"]),
    );
  }
}

enum NotificationType {
  invite,
  follow,
  message,
  announcement,
  questAssigned,
  questCompleted,
  none;

  static NotificationType fromText(String type) {
    switch (type.toUpperCase()) {
      case 'INVITE':
      case 'INIVTE':
        return NotificationType.invite;
      case 'FOLLOW':
        return NotificationType.follow;
      case 'MESSAGE':
        return NotificationType.message;
      case 'ANNOUNCEMENT':
      case 'ALERT':
        return NotificationType.announcement;
      case 'QUEST_ASSIGNED':
        return NotificationType.questAssigned;
      case 'QUEST_COMPLETED':
        return NotificationType.questCompleted;
      default:
        return NotificationType.none;
    }
  }
}

extension NotificationTypeText on NotificationType {
  String get backendValue {
    switch (this) {
      case NotificationType.invite:
        return 'INVITE';
      case NotificationType.follow:
        return 'FOLLOW';
      case NotificationType.message:
        return 'MESSAGE';
      case NotificationType.announcement:
        return 'ANNOUNCEMENT';
      case NotificationType.questAssigned:
        return 'QUEST_ASSIGNED';
      case NotificationType.questCompleted:
        return 'QUEST_COMPLETED';
      case NotificationType.none:
        return 'NONE';
    }
  }
}
