import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/item_model.dart';

class ItemsProvider {
  ItemsProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<List<ItemModel>> fetchPofelItems(String pofelId) async {
    final items = await _repository.listDocuments(
      AppwriteEnvironment.pofelItemsCollectionId,
    );
    final filtered = items
        .where((item) => item['pofelId'] == pofelId)
        .toList()
      ..sort(
        (a, b) =>
            DateTime.parse(a['addedOn'] as String).compareTo(
              DateTime.parse(b['addedOn'] as String),
            ),
      );
    return filtered.map(ItemModel.fromMap).toList();
  }

  Future<void> addItem(
    String pofelId,
    String userUid,
    String name,
    int count,
    double price,
    DateTime addedOn,
    ItemType itemType,
  ) async {
    final user = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      userUid,
    );
    await _repository.createDocument(
      collectionId: AppwriteEnvironment.pofelItemsCollectionId,
      data: {
        'pofelId': pofelId,
        'name': name,
        'count': count,
        'addedBy': user?['name'] ?? 'Unknown',
        'addedByUid': userUid,
        'addedByProfilePic': user?['profile_pic'] ??
            'https://ui-avatars.com/api/?background=8F3BB7&color=ffffff&name=Unknown',
        'itemType': getStringFromType(itemType),
        'price': price,
        'addedOn': serializeDateTime(addedOn),
      },
    );
  }

  Future<void> removeItem(String pofelId, DateTime createdAt) async {
    final items = await _repository.listDocuments(
      AppwriteEnvironment.pofelItemsCollectionId,
    );
    final match = items.cast<Map<String, dynamic>?>().firstWhere(
          (item) =>
              item != null &&
              item['pofelId'] == pofelId &&
              item['addedOn'] == serializeDateTime(createdAt),
          orElse: () => null,
        );
    if (match == null) {
      return;
    }

    await _repository.deleteDocument(
      collectionId: AppwriteEnvironment.pofelItemsCollectionId,
      documentId: match[r'$id'] as String,
    );
  }
}
