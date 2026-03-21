import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';

class UserProvider {
  UserProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<UserModel> fetchUserData(String userUid) async {
    final userDoc = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      userUid,
    );
    if (userDoc == null) {
      return const UserModel(uid: '');
    }

    final follows = await _repository.listDocuments(
      AppwriteEnvironment.followsCollectionId,
    );
    final users = await _repository.listDocuments(
      AppwriteEnvironment.usersCollectionId,
    );

    final followers = follows
        .where((follow) => follow['followingUid'] == userUid)
        .map((follow) => follow['followerUid'] as String)
        .toSet();
    final following = follows
        .where((follow) => follow['followerUid'] == userUid)
        .map((follow) => follow['followingUid'] as String)
        .toSet();

    List<ProfileModel> profilesFor(Set<String> ids) {
      return users
          .where((user) => ids.contains(user['uid']))
          .map(ProfileModel.fromMap)
          .toList();
    }

    final oldUser = UserModel.fromMap(userDoc);
    return UserModel(
      uid: oldUser.uid,
      name: oldUser.name,
      email: oldUser.email,
      photo: oldUser.photo,
      isPremium: oldUser.isPremium,
      followers: profilesFor(followers),
      following: profilesFor(following),
    );
  }

  Future<void> updateUserName(String userUid, String newName) async {
    final userDoc = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      userUid,
    );
    if (userDoc == null) {
      return;
    }

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.usersCollectionId,
      documentId: userUid,
      data: {
        ...sanitizeDocumentData(userDoc),
        'name': newName,
      },
    );
  }

  Future<void> updateProfilePic(String userUid, XFile image) async {
    final bytes = await image.readAsBytes();
    final fileId = await _repository.uploadFile(
      filename: 'profile_$userUid.png',
      bytes: bytes,
      fileId: 'profile-$userUid',
    );
    final imageUrl = _repository.getFileView(fileId);

    final userDoc = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      userUid,
    );
    if (userDoc == null) {
      return;
    }

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.usersCollectionId,
      documentId: userUid,
      data: {
        ...sanitizeDocumentData(userDoc),
        'profile_pic': imageUrl,
      },
    );
  }

  Future<void> buyPremium(String userUid) async {
    final userDoc = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      userUid,
    );
    if (userDoc == null) {
      return;
    }

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.usersCollectionId,
      documentId: userUid,
      data: {
        ...sanitizeDocumentData(userDoc),
        'isPremium': true,
        'premiumLevel': ((userDoc['premiumLevel'] ?? 0) as num).toInt() + 1,
      },
    );
  }
}
