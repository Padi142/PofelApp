import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';

class SocialProvider {
  SocialProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<void> follow(String currentUserId, String userId) async {
    if (currentUserId == userId) {
      return;
    }

    final follows = await _repository.listDocuments(
      AppwriteEnvironment.followsCollectionId,
    );
    final alreadyFollowing = follows.any(
      (follow) =>
          follow['followerUid'] == currentUserId &&
          follow['followingUid'] == userId,
    );
    if (alreadyFollowing) {
      return;
    }

    await _repository.createDocument(
      collectionId: AppwriteEnvironment.followsCollectionId,
      data: {
        'followerUid': currentUserId,
        'followingUid': userId,
        'followedOn': serializeDateTime(DateTime.now()),
      },
    );

    final currentUser = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      currentUserId,
    );
    if (currentUser != null) {
      await _repository.createDocument(
        collectionId: AppwriteEnvironment.notificationsCollectionId,
        data: {
          'userId': currentUserId,
          'recipientUserId': userId,
          'pofelId': '',
          'message': '${currentUser['name']} tě začal/a sledovat.',
          'sentByName': currentUser['name'],
          'sentByProfilePic': currentUser['profile_pic'],
          'type': 'FOLLOW',
          'shown': false,
          'sentOn': serializeDateTime(DateTime.now()),
          'id': '',
        },
      );
    }
  }

  Future<List<ProfileModel>> search(String query) async {
    final users = await _repository.listDocuments(
      AppwriteEnvironment.usersCollectionId,
    );
    final normalizedQuery = query.trim().toLowerCase();

    return users
        .where((user) =>
            (user['name'] ?? '')
                .toString()
                .toLowerCase()
                .contains(normalizedQuery) ||
            (user['uid'] ?? '').toString().toLowerCase().contains(normalizedQuery))
        .take(10)
        .map(ProfileModel.fromMap)
        .toList();
  }

  Future<List<ProfileModel>> myFollowing(String uid) async {
    final follows = await _repository.listDocuments(
      AppwriteEnvironment.followsCollectionId,
    );
    final users = await _repository.listDocuments(
      AppwriteEnvironment.usersCollectionId,
    );

    final followingIds = follows
        .where((follow) => follow['followerUid'] == uid)
        .map((follow) => follow['followingUid'] as String)
        .toSet();

    return users
        .where((user) => followingIds.contains(user['uid']))
        .map(ProfileModel.fromMap)
        .toList();
  }

  Future<bool> isFollowing(String uid, String followeUid) async {
    final follows = await _repository.listDocuments(
      AppwriteEnvironment.followsCollectionId,
    );
    return follows.any(
      (follow) => follow['followerUid'] == uid && follow['followingUid'] == followeUid,
    );
  }

  Future<void> inviteUserToPofel({
    required String currentUserId,
    required String userId,
    required String pofelName,
    required String pofelJoinCode,
  }) async {
    final currentUser = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      currentUserId,
    );
    if (currentUser == null) {
      return;
    }

    await _repository.createDocument(
      collectionId: AppwriteEnvironment.notificationsCollectionId,
      data: {
        'userId': currentUserId,
        'recipientUserId': userId,
        'pofelId': pofelJoinCode,
        'message': '${currentUser['name']} tě zve na $pofelName.',
        'sentByName': currentUser['name'],
        'sentByProfilePic': currentUser['profile_pic'],
        'type': 'INVITE',
        'shown': false,
        'sentOn': serializeDateTime(DateTime.now()),
        'id': '',
      },
    );
  }
}
