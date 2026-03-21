import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';

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
        (a, b) =>
            DateTime.parse(b['sentOn'] as String).compareTo(
              DateTime.parse(a['sentOn'] as String),
            ),
      );

    return filtered.map(NotificationModel.notificationFromMap).toList();
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

  Future<void> notifyPofelUsers({
    required String sentByUid,
    required String sentByName,
    required String sentByProfilePic,
    required String pofelId,
    required String message,
  }) async {
    final signedUsers = await _repository.listDocuments(
      AppwriteEnvironment.signedUsersCollectionId,
    );
    for (final user in signedUsers.where((user) =>
        user['pofelId'] == pofelId && user['uid'] != sentByUid)) {
      await _repository.createDocument(
        collectionId: AppwriteEnvironment.notificationsCollectionId,
        data: {
          'userId': sentByUid,
          'recipientUserId': user['uid'],
          'pofelId': pofelId,
          'message': message,
          'sentByName': sentByName,
          'sentByProfilePic': sentByProfilePic,
          'type': 'MESSAGE',
          'shown': false,
          'sentOn': serializeDateTime(DateTime.now()),
          'id': '',
        },
      );
    }
  }
}
