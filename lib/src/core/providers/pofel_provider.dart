import 'dart:math';

import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/geo_point.dart';
import 'package:pofel_app/src/core/models/pofel_image_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/core/models/public_pofel_model.dart';

class PofelProvider {
  PofelProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<List<PofelModel>> fetchPofels(String userUid) async {
    final pofels = await _repository.listDocuments(
      AppwriteEnvironment.activePofelsCollectionId,
    );
    final sortDate = DateTime.now().subtract(const Duration(days: 4));
    final filtered = pofels.where((doc) {
      final signedUsers = parseStringList(doc['signedUsers']);
      return signedUsers.contains(userUid) &&
          parseDateTime(doc['dateFrom']).isAfter(sortDate);
    }).toList()
      ..sort(
        (a, b) => parseDateTime(a['dateFrom'])
            .compareTo(parseDateTime(b['dateFrom'])),
      );
    return Future.wait(filtered.map(_mapPofelSummary));
  }

  Future<List<PublicPofelModel>> fetchPublicPofels(String userUid) async {
    final pofels = await _repository.listDocuments(
      AppwriteEnvironment.activePofelsCollectionId,
    );
    final sortDate = DateTime.now().subtract(const Duration(days: 4));

    return pofels
        .where((doc) =>
            parseBool(doc['isPublic']) &&
            parseDateTime(doc['dateFrom']).isAfter(sortDate))
        .map(
          (doc) => PublicPofelModel(
            name: doc['name'],
            description: doc['description'],
            adminUid: doc['adminUid'],
            dateFrom: parseDateTime(doc['dateFrom']),
            dateTo: parseDateTime(doc['dateTo']),
            joinCode: doc['joinId'],
            spotifyLink: doc['spotifyLink'] ?? '',
            pofelId: doc['pofelId'],
            signedUsers: parseStringList(doc['signedUsers']).length,
            createdAt: parseDateTime(doc['createdAt']),
            pofelLocation: parseGeoPoint(doc['pofelLocation']),
            showDrugItems: parseBool(doc['showDrugItems']),
            isPremium: parseBool(doc['isPremium']),
            isPublic: parseBool(doc['isPublic']),
            photos: const <PofelImage>[],
          ),
        )
        .toList();
  }

  Future<List<PofelModel>> fetchPastPofels(String userUid) async {
    final pofels = await _repository.listDocuments(
      AppwriteEnvironment.activePofelsCollectionId,
    );
    final sortDate = DateTime.now().subtract(const Duration(days: 4));
    final filtered = pofels.where((doc) {
      final signedUsers = parseStringList(doc['signedUsers']);
      return signedUsers.contains(userUid) &&
          parseDateTime(doc['dateFrom']).isBefore(sortDate);
    }).toList()
      ..sort(
        (a, b) => parseDateTime(b['dateFrom'])
            .compareTo(parseDateTime(a['dateFrom'])),
      );
    return Future.wait(filtered.map(_mapPofelSummary));
  }

  Future<PofelModel> getPofel(String pofelId) async {
    final document = await _repository.getDocument(
      AppwriteEnvironment.activePofelsCollectionId,
      pofelId,
    );
    if (document == null) {
      throw Exception('Pofel not found');
    }
    return _mapPofel(document);
  }

  Future<PofelModel> getPofelByJoinId(String joinId) async {
    final pofels = await _repository.listDocuments(
      AppwriteEnvironment.activePofelsCollectionId,
    );
    final document = pofels.cast<Map<String, dynamic>?>().firstWhere(
          (doc) => doc != null && doc['joinId'] == joinId,
          orElse: () => null,
        );
    if (document == null) {
      throw Exception('Pofel not found');
    }
    return _mapPofel(document);
  }

  Future<String> joinPofel(String uid, String joinId) async {
    final pofels = await _repository.listDocuments(
      AppwriteEnvironment.activePofelsCollectionId,
    );
    final users = await _repository.listDocuments(
      AppwriteEnvironment.usersCollectionId,
    );

    final pofelDoc = pofels.cast<Map<String, dynamic>?>().firstWhere(
          (doc) => doc != null && doc['joinId'] == joinId,
          orElse: () => null,
        );
    if (pofelDoc == null) {
      return 'Nepodařilo se najít pofel.';
    }

    final userDoc = users.cast<Map<String, dynamic>?>().firstWhere(
          (doc) => doc != null && doc['uid'] == uid,
          orElse: () => null,
        );
    if (userDoc == null) {
      return 'Nepodařilo se načíst uživatele.';
    }

    final joinedUsers = parseStringList(pofelDoc['signedUsers']);
    final canJoin = !joinedUsers.contains(uid);
    if (!canJoin) {
      return 'Retarde, nemůžeš se dvakrat připojit na stejný pofel';
    }

    joinedUsers.add(uid);
    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.activePofelsCollectionId,
      documentId: pofelDoc[r'$id'] as String,
      data: {
        ...sanitizeDocumentData(pofelDoc),
        'signedUsers': joinedUsers,
      },
    );

    await _upsertSignedUserDocument(
      pofelId: pofelDoc['pofelId'] as String,
      uid: userDoc['uid'] as String,
      data: {
        'pofelId': pofelDoc['pofelId'],
        'name': userDoc['name'],
        'uid': userDoc['uid'],
        'profile_pic': userDoc['profile_pic'],
        'isPremium': userDoc['isPremium'] ?? false,
        'acceptedInvitation': true,
        'signedOn': serializeDateTime(DateTime.now()),
        'willArrive': serializeDateTime(DateTime.utc(1989, 11, 9)),
        'chatNotification': true,
      },
    );

    return '';
  }

  Future<void> createPofel(
    String name,
    String description,
    String adminUid,
    DateTime dateFrom,
    DateTime dateTo,
  ) async {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(
          Iterable.generate(
            length,
            (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
          ),
        );

    final documentId = getRandomString(18);
    final admin = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      adminUid,
    );

    await _repository.createDocument(
      collectionId: AppwriteEnvironment.activePofelsCollectionId,
      documentId: documentId,
      data: {
        'name': name,
        'description': description,
        'createdAt': serializeDateTime(DateTime.now()),
        'dateFrom': serializeDateTime(dateFrom),
        'dateTo': serializeDateTime(dateTo),
        'pofelLocation': serializeGeoPoint(const GeoPoint(0, 0)),
        'pofelId': documentId,
        'joinId': documentId.substring(0, 5),
        'spotifyLink': '',
        'adminUid': adminUid,
        'signedUsers': [adminUid],
        'isPremium': false,
        'isPublic': false,
        'showDrugItems': false,
      },
    );
    await _upsertSignedUserDocument(
      pofelId: documentId,
      uid: adminUid,
      data: {
        'pofelId': documentId,
        'signedOn': serializeDateTime(DateTime.now()),
        'acceptedInvitation': true,
        'uid': adminUid,
        'name': admin?['name'] ?? 'Admin',
        'profile_pic': admin?['profile_pic'] ??
            'https://ui-avatars.com/api/?background=8F3BB7&color=ffffff&name=Admin',
        'isPremium': admin?['isPremium'] ?? false,
        'willArrive': serializeDateTime(DateTime.utc(1989, 11, 9)),
        'chatNotification': true,
      },
    );
  }

  Future<void> updateName(String name, String pofelId) async {
    await _updatePofelFields(pofelId, {'name': name});
  }

  Future<void> updateDesc(String desc, String pofelId) async {
    await _updatePofelFields(pofelId, {'description': desc});
  }

  Future<void> updateDatefrom(String pofelId, DateTime newdate) async {
    await _updatePofelFields(pofelId, {'dateFrom': serializeDateTime(newdate)});
  }

  Future<void> updateSpotifyLink(String pofelId, String newLink) async {
    await _updatePofelFields(pofelId, {'spotifyLink': newLink});
  }

  Future<void> updatePofelLocation(String pofelId, GeoPoint newLocation) async {
    await _updatePofelFields(
      pofelId,
      {'pofelLocation': serializeGeoPoint(newLocation)},
    );
  }

  Future<void> updateUserArrivalDate(
    String pofelId,
    String uid,
    DateTime newdate,
  ) async {
    final signedUserDoc = await _getSignedUserDocument(pofelId, uid);
    if (signedUserDoc == null) {
      return;
    }
    final documentId = signedUserDoc[r'$id'] as String;

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.signedUsersCollectionId,
      documentId: documentId,
      data: {
        ...sanitizeDocumentData(signedUserDoc),
        'willArrive': serializeDateTime(newdate),
      },
    );
  }

  Future<void> updateChatNotification(
    String pofelId,
    String uid,
    bool enabled,
  ) async {
    final signedUserDoc = await _getSignedUserDocument(pofelId, uid);
    if (signedUserDoc == null) {
      return;
    }
    final documentId = signedUserDoc[r'$id'] as String;

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.signedUsersCollectionId,
      documentId: documentId,
      data: {
        ...sanitizeDocumentData(signedUserDoc),
        'chatNotification': enabled,
      },
    );
  }

  Future<void> toggleShowDrug(String pofelId, bool showDrugs) async {
    await _updatePofelFields(pofelId, {'showDrugItems': !showDrugs});
  }

  Future<void> updateIsPublic(String pofelId, bool isPublic) async {
    await _updatePofelFields(pofelId, {'isPublic': !isPublic});
  }

  Future<void> changeAdmin(String pofelId, String uid) async {
    await _updatePofelFields(pofelId, {'adminUid': uid});
  }

  Future<void> upgradePofel(String pofelId) async {
    await _updatePofelFields(pofelId, {'isPremium': true});
  }

  Future<void> leavePofel(String pofelId, String uid) async {
    final pofelDoc = await _repository.getDocument(
      AppwriteEnvironment.activePofelsCollectionId,
      pofelId,
    );
    if (pofelDoc == null) {
      return;
    }

    final signedUsers = parseStringList(pofelDoc['signedUsers'])
      ..removeWhere((signedUser) => signedUser == uid);
    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.activePofelsCollectionId,
      documentId: pofelId,
      data: {
        ...sanitizeDocumentData(pofelDoc),
        'signedUsers': signedUsers,
      },
    );

    final signedUserDocs = await _getSignedUserDocuments(pofelId, uid);
    for (final document in signedUserDocs) {
      await _repository.deleteDocument(
        collectionId: AppwriteEnvironment.signedUsersCollectionId,
        documentId: document[r'$id'] as String,
      );
    }
  }

  Future<void> deletePofel(String pofelId) async {
    await _deleteWhere(
      AppwriteEnvironment.signedUsersCollectionId,
      (doc) => doc['pofelId'] == pofelId,
    );
    await _deleteWhere(
      AppwriteEnvironment.pofelMessagesCollectionId,
      (doc) => doc['pofelId'] == pofelId,
    );
    await _deleteWhere(
      AppwriteEnvironment.pofelItemsCollectionId,
      (doc) => doc['pofelId'] == pofelId,
    );
    await _deleteWhere(
      AppwriteEnvironment.pofelPhotosCollectionId,
      (doc) => doc['pofelId'] == pofelId,
    );
    await _deleteWhere(
      AppwriteEnvironment.pofelTodosCollectionId,
      (doc) => doc['pofelId'] == pofelId,
    );

    await _repository.deleteDocument(
      collectionId: AppwriteEnvironment.activePofelsCollectionId,
      documentId: pofelId,
    );
  }

  Future<PofelModel> _mapPofelSummary(Map<String, dynamic> doc) async {
    final signedUsers = await _loadSignedUsersForPofel(doc);
    return PofelModel(
      name: doc['name'],
      description: doc['description'],
      adminUid: doc['adminUid'],
      dateFrom: parseDateTime(doc['dateFrom']),
      dateTo: parseDateTime(doc['dateTo']),
      joinCode: doc['joinId'],
      spotifyLink: doc['spotifyLink'] ?? '',
      pofelId: doc['pofelId'],
      signedUsers: signedUsers,
      createdAt: parseDateTime(doc['createdAt']),
      pofelLocation: parseGeoPoint(doc['pofelLocation']),
      showDrugItems: parseBool(doc['showDrugItems']),
      isPremium: parseBool(doc['isPremium']),
      isPublic: parseBool(doc['isPublic']),
      photos: const [],
    );
  }

  Future<PofelModel> _mapPofel(Map<String, dynamic> doc) async {
    final signedUsers = await _loadSignedUsersForPofel(doc);
    final photos = await _repository.listDocuments(
      AppwriteEnvironment.pofelPhotosCollectionId,
    );

    return PofelModel(
      name: doc['name'],
      description: doc['description'],
      adminUid: doc['adminUid'],
      dateFrom: parseDateTime(doc['dateFrom']),
      dateTo: parseDateTime(doc['dateTo']),
      joinCode: doc['joinId'],
      spotifyLink: doc['spotifyLink'] ?? '',
      pofelId: doc['pofelId'],
      signedUsers: signedUsers,
      createdAt: parseDateTime(doc['createdAt']),
      pofelLocation: parseGeoPoint(doc['pofelLocation']),
      showDrugItems: parseBool(doc['showDrugItems']),
      isPremium: parseBool(doc['isPremium']),
      isPublic: parseBool(doc['isPublic']),
      photos: photos
          .where((photo) => photo['pofelId'] == doc['pofelId'])
          .map(PofelImage.fromMap)
          .toList(),
    );
  }

  Future<void> _updatePofelFields(
    String pofelId,
    Map<String, dynamic> fields,
  ) async {
    final pofelDoc = await _repository.getDocument(
      AppwriteEnvironment.activePofelsCollectionId,
      pofelId,
    );
    if (pofelDoc == null) {
      return;
    }
    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.activePofelsCollectionId,
      documentId: pofelId,
      data: {
        ...sanitizeDocumentData(pofelDoc),
        ...fields,
      },
    );
  }

  Future<void> _deleteWhere(
    String collectionId,
    bool Function(Map<String, dynamic>) test,
  ) async {
    final documents = await _repository.listDocuments(collectionId);
    for (final document in documents.where(test)) {
      await _repository.deleteDocument(
        collectionId: collectionId,
        documentId: document[r'$id'] as String,
      );
    }
  }

  Future<Map<String, dynamic>?> _getSignedUserDocument(
    String pofelId,
    String uid,
  ) async {
    final documents = await _getSignedUserDocuments(pofelId, uid);
    if (documents.isEmpty) {
      return null;
    }
    return documents.first;
  }

  Future<List<Map<String, dynamic>>> _getSignedUserDocuments(
    String pofelId,
    String uid,
  ) async {
    final documents = await _repository.listDocuments(
      AppwriteEnvironment.signedUsersCollectionId,
    );
    return documents
        .where(
          (document) =>
              document['pofelId'] == pofelId && document['uid'] == uid,
        )
        .toList();
  }

  Future<void> _upsertSignedUserDocument({
    required String pofelId,
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final existingDocument = await _getSignedUserDocument(pofelId, uid);
    if (existingDocument == null) {
      await _repository.createDocument(
        collectionId: AppwriteEnvironment.signedUsersCollectionId,
        data: data,
      );
      return;
    }

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.signedUsersCollectionId,
      documentId: existingDocument[r'$id'] as String,
      data: {
        ...sanitizeDocumentData(existingDocument),
        ...data,
      },
    );
  }

  Future<List<PofelUserModel>> _loadSignedUsersForPofel(
    Map<String, dynamic> pofelDoc,
  ) async {
    final signedUserDocs = await _repository.listDocuments(
      AppwriteEnvironment.signedUsersCollectionId,
    );
    final users = await _repository.listDocuments(
      AppwriteEnvironment.usersCollectionId,
    );
    final userByUid = {
      for (final user in users) user['uid'] as String: user,
    };
    final signedUserByUid = {
      for (final document in signedUserDocs.where(
        (document) => document['pofelId'] == pofelDoc['pofelId'],
      ))
        document['uid'] as String: document,
    };

    return parseStringList(pofelDoc['signedUsers'])
        .map((uid) {
          final signedUserDoc = signedUserByUid[uid];
          if (signedUserDoc != null) {
            return PofelUserModel.fromMap(signedUserDoc);
          }

          final userDoc = userByUid[uid];
          if (userDoc == null) {
            return null;
          }

          return PofelUserModel(
            uid: uid,
            name: userDoc['name'] ?? 'Pofel user',
            photo: userDoc['profile_pic'] ??
                'https://ui-avatars.com/api/?background=8F3BB7&color=ffffff&name=Pofel%20user',
            acceptedInvitation: true,
            joinedOn: parseDateTime(pofelDoc['createdAt']),
            willArrive: DateTime.utc(1989, 11, 9).toLocal(),
            chatNotification: true,
            isPremium: userDoc['isPremium'] ?? false,
          );
        })
        .whereType<PofelUserModel>()
        .toList();
  }
}
