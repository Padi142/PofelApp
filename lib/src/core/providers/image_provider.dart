import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/pofel_image_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';

class ImageProvider {
  ImageProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<void> uploadPicture(
    String pofelId,
    XFile photo,
    PofelUserModel user,
  ) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = await photo.readAsBytes();
    final fileId = await _repository.uploadFile(
      filename: '$imageName.png',
      bytes: bytes,
    );
    final imageUrl = _repository.getFileView(fileId);

    await _repository.createDocument(
      collectionId: AppwriteEnvironment.pofelPhotosCollectionId,
      documentId: imageName,
      data: {
        'pofelId': pofelId,
        'fileId': fileId,
        'photo': imageUrl,
        'name': imageName,
        'uploadedAt': serializeDateTime(DateTime.now()),
        'uploadedByName': user.name,
        'uploadedByUid': user.uid,
      },
    );
  }

  Future<List<PofelImage>> fetchPhotos(String pofelId) async {
    final photos = await _repository.listDocuments(
      AppwriteEnvironment.pofelPhotosCollectionId,
    );
    final filtered = photos
        .where((photo) => photo['pofelId'] == pofelId)
        .toList()
      ..sort(
        (a, b) =>
            DateTime.parse(b['uploadedAt'] as String).compareTo(
              DateTime.parse(a['uploadedAt'] as String),
            ),
      );

    return filtered.map(PofelImage.fromMap).toList();
  }

  Future<void> downloadImage(String pofelId, PofelImage image) async {
    try {
      final response = await Dio().get(
        image.photo,
        options: Options(responseType: ResponseType.bytes),
      );
      await Gal.putImageBytes(
        Uint8List.fromList(response.data),
        name: image.name,
      );
    } catch (_) {}
  }
}
