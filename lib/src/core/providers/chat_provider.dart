import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/message_model.dart';

class ChatProvider {
  ChatProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<List<MessageModel>> fetchFirstMessages(String pofelId) async {
    final documents = await _repository.listDocuments(
      AppwriteEnvironment.pofelMessagesCollectionId,
    );
    final filtered = documents
        .where((message) => message['pofelId'] == pofelId)
        .toList()
      ..sort(
        (a, b) =>
            DateTime.parse(a['sentOn'] as String).compareTo(
              DateTime.parse(b['sentOn'] as String),
            ),
      );

    return filtered.take(50).map(MessageModel.fromMap).toList();
  }

  Future<void> sendMessage(MessageModel message, String pofelId) async {
    await _repository.createDocument(
      collectionId: AppwriteEnvironment.pofelMessagesCollectionId,
      data: {
        'pofelId': pofelId,
        'message': message.message,
        'sentByName': message.sentByName,
        'sentByUid': message.sentByUid,
        'sentByProfilePic': message.sentByProfilePic,
        'sentOn': serializeDateTime(message.sentOn),
      },
    );
  }
}
