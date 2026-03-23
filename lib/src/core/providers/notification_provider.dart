import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/message_model.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:appwrite/appwrite.dart';

class NotificationProvider {
  NotificationProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<List<NotificationModel>> fetchNotifications(String userId) async {
    final notifications = await _repository.listDocuments(
      AppwriteEnvironment.notificationsCollectionId,
    );

    final filtered = notifications
        .where((notification) => notification['recipientUserId'] == userId)
        .toList()
      ..sort(
        (a, b) => parseDateTime(b['sentOn']).compareTo(
          parseDateTime(a['sentOn']),
        ),
      );

    return filtered.map(NotificationModel.notificationFromMap).toList();
  }

  Future<int> fetchUnreadCount(String userId) async {
    final notifications = await fetchNotifications(userId);
    return notifications.where((notification) => !notification.shown).length;
  }

  Future<void> notificationMakeRead(String userId, String notId) async {
    final document = await _repository.getDocument(
      AppwriteEnvironment.notificationsCollectionId,
      notId,
    );
    if (document == null || document['recipientUserId'] != userId) {
      return;
    }

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.notificationsCollectionId,
      documentId: notId,
      data: {
        ...sanitizeDocumentData(document),
        'shown': true,
      },
    );
  }

  Future<void> markAllAsRead(String userId) async {
    final notifications = await _repository.listDocuments(
      AppwriteEnvironment.notificationsCollectionId,
    );

    for (final notification in notifications.where((notification) =>
        notification['recipientUserId'] == userId &&
        !parseBool(notification['shown']))) {
      await _repository.updateDocument(
        collectionId: AppwriteEnvironment.notificationsCollectionId,
        documentId: (notification[r'$id'] ?? notification['id']).toString(),
        data: {
          ...sanitizeDocumentData(notification),
          'shown': true,
        },
      );
    }
  }

  Future<void> createNotification({
    required String actorUserId,
    required String recipientUserId,
    required String sentByName,
    required String sentByProfilePic,
    required String message,
    required NotificationType type,
    String pofelId = '',
  }) async {
    if (recipientUserId.isEmpty || recipientUserId == actorUserId) {
      return;
    }

    final documentId = ID.unique();
    await _repository.createDocument(
      collectionId: AppwriteEnvironment.notificationsCollectionId,
      documentId: documentId,
      data: {
        'userId': actorUserId,
        'recipientUserId': recipientUserId,
        'pofelId': pofelId,
        'message': message,
        'sentByName': sentByName,
        'sentByProfilePic': sentByProfilePic,
        'type': type.backendValue,
        'shown': false,
        'sentOn': serializeDateTime(DateTime.now()),
        'id': documentId,
      },
    );
  }

  Future<void> notifyPofelUsers({
    required String sentByUid,
    required String sentByName,
    required String sentByProfilePic,
    required String pofelId,
    required String message,
    NotificationType type = NotificationType.announcement,
    bool respectChatPreference = false,
  }) async {
    final signedUsers = await _repository.listDocuments(
      AppwriteEnvironment.signedUsersCollectionId,
    );
    for (final user in signedUsers.where(
        (user) => user['pofelId'] == pofelId && user['uid'] != sentByUid)) {
      if (respectChatPreference &&
          !parseBool(user['chatNotification'], defaultValue: true)) {
        continue;
      }

      await createNotification(
        actorUserId: sentByUid,
        recipientUserId: user['uid'].toString(),
        pofelId: pofelId,
        message: message,
        sentByName: sentByName,
        sentByProfilePic: sentByProfilePic,
        type: type,
      );
    }
  }

  Future<void> notifyChatMessage({
    required String pofelId,
    required MessageModel message,
  }) async {
    await notifyPofelUsers(
      sentByUid: message.sentByUid,
      sentByName: message.sentByName,
      sentByProfilePic: message.sentByProfilePic,
      pofelId: pofelId,
      message: '${message.sentByName}: ${message.message}',
      type: NotificationType.message,
      respectChatPreference: true,
    );
  }

  Future<void> notifyQuestAssigned({
    required String pofelId,
    required TodoModel todo,
  }) async {
    await createNotification(
      actorUserId: todo.assignedByUid,
      recipientUserId: todo.assignedToUid,
      pofelId: pofelId,
      sentByName: todo.assignedByName,
      sentByProfilePic: todo.assignedByProfilePic,
      message: '${todo.assignedByName} ti přiřadil/a quest: ${todo.todoTitle}',
      type: NotificationType.questAssigned,
    );
  }

  Future<void> notifyQuestCompleted({
    required String pofelId,
    required TodoModel todo,
  }) async {
    await createNotification(
      actorUserId: todo.assignedToUid,
      recipientUserId: todo.assignedByUid,
      pofelId: pofelId,
      sentByName: todo.assignedToName,
      sentByProfilePic: todo.assignedToProfilePic,
      message: '${todo.assignedToName} dokončil/a quest: ${todo.todoTitle}',
      type: NotificationType.questCompleted,
    );
  }
}
