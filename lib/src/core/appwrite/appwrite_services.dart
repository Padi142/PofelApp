import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';

class AppwriteServices {
  AppwriteServices._()
      : client = Client()
            .setEndpoint(AppwriteEnvironment.endpoint)
            .setProject(AppwriteEnvironment.projectId) {
    if (!kIsWeb) {
      client.setSelfSigned(status: true);
    }
  }

  static final AppwriteServices instance = AppwriteServices._();

  final Client client;

  late final Account account = Account(client);
  late final Databases databases = Databases(client);
  late final Storage storage = Storage(client);
}

class AppwriteRepository {
  AppwriteRepository({AppwriteServices? services})
      : _services = services ?? AppwriteServices.instance;

  final AppwriteServices _services;

  Future<List<Map<String, dynamic>>> listDocuments(String collectionId) async {
    if (!AppwriteEnvironment.hasDatabaseConfig) {
      return const [];
    }
    final response = await _services.databases.listDocuments(
      databaseId: AppwriteEnvironment.databaseId,
      collectionId: collectionId,
    );
    return response.documents.map(_documentToMap).toList();
  }

  Future<Map<String, dynamic>?> getDocument(
    String collectionId,
    String documentId,
  ) async {
    if (!AppwriteEnvironment.hasDatabaseConfig) {
      return null;
    }
    try {
      final document = await _services.databases.getDocument(
        databaseId: AppwriteEnvironment.databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
      return _documentToMap(document);
    } on AppwriteException {
      return null;
    }
  }

  Future<Map<String, dynamic>> createDocument({
    required String collectionId,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    final document = await _services.databases.createDocument(
      databaseId: AppwriteEnvironment.databaseId,
      collectionId: collectionId,
      documentId: documentId ?? ID.unique(),
      data: data,
    );
    return _documentToMap(document);
  }

  Future<Map<String, dynamic>> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final document = await _services.databases.updateDocument(
      databaseId: AppwriteEnvironment.databaseId,
      collectionId: collectionId,
      documentId: documentId,
      data: data,
    );
    return _documentToMap(document);
  }

  Future<void> deleteDocument({
    required String collectionId,
    required String documentId,
  }) async {
    await _services.databases.deleteDocument(
      databaseId: AppwriteEnvironment.databaseId,
      collectionId: collectionId,
      documentId: documentId,
    );
  }

  Future<String> uploadFile({
    required String filename,
    required Uint8List bytes,
    String? fileId,
  }) async {
    final file = await _services.storage.createFile(
      bucketId: AppwriteEnvironment.bucketId,
      fileId: fileId ?? ID.unique(),
      file: InputFile.fromBytes(bytes: bytes, filename: filename),
    );
    return file.$id;
  }

  String getFileView(String fileId) {
    return _services.storage
        .getFileView(
          bucketId: AppwriteEnvironment.bucketId,
          fileId: fileId,
        )
        .toString();
  }

  Map<String, dynamic> _documentToMap(models.Document document) {
    return <String, dynamic>{
      '\$id': document.$id,
      ...document.data,
    };
  }
}
