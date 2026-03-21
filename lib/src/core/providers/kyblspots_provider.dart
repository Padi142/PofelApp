import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/geo_point.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:pofel_app/src/core/models/kyblspot_review_model.dart';

class KyblspotsProvider {
  KyblspotsProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<List<KyblspotModel>> fetchKyblspots(String eventID) async {
    final spots = await _repository.listDocuments(
      AppwriteEnvironment.kyblspotsCollectionId,
    );
    return spots
        .map(
          (doc) => KyblspotModel(
            location: parseGeoPoint(doc['location']),
            weight: parseInt(doc['weight']),
            rating: parseDouble(doc['rating']),
            name: doc['name'],
            spotId: doc[r'$id'] as String,
            createdBy: doc['createdBy'],
            description: doc['description'],
          ),
        )
        .toList();
  }

  Future<List<SpotReviewModel>> fetchKyblspotReviews(String spotId) async {
    final reviews = await _repository.listDocuments(
      AppwriteEnvironment.kyblspotReviewsCollectionId,
    );
    return reviews
        .where((review) => review['spotId'] == spotId)
        .map(
          (doc) => SpotReviewModel(
            review: doc['review'],
            reviewedByProfilePic: doc['reviewedByProfilePic'],
            rating: parseDouble(doc['rating']),
            reviewedByUid: doc['reviewedByUid'],
            reviewedByName: doc['reviewedByName'],
            isPremium: parseBool(doc['isPremium']),
            reviewId: doc[r'$id'] as String,
          ),
        )
        .toList();
  }

  Future<void> addKyblspot(KyblspotModel model) async {
    await _repository.createDocument(
      collectionId: AppwriteEnvironment.kyblspotsCollectionId,
      data: {
        'name': model.name,
        'location': serializeGeoPoint(
          GeoPoint(model.location!.latitude, model.location!.longitude),
        ),
        'description': model.description,
        'createdBy': model.createdBy,
        'createdAt': serializeDateTime(DateTime.now()),
        'weight': model.weight,
        'rating': model.rating,
      },
    );
  }

  Future<void> addReview(SpotReviewModel review, KyblspotModel kyblspot) async {
    await _repository.createDocument(
      collectionId: AppwriteEnvironment.kyblspotReviewsCollectionId,
      data: {
        'spotId': kyblspot.spotId,
        'reviewedByUid': review.reviewedByUid,
        'reviewedByProfilePic': review.reviewedByProfilePic,
        'reviewedByName': review.reviewedByName,
        'isPremium': review.isPremium,
        'review': review.review,
        'rating': review.rating,
      },
    );

    final newRating = (kyblspot.weight * kyblspot.rating + review.rating) /
        (kyblspot.weight + 1);

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.kyblspotsCollectionId,
      documentId: kyblspot.spotId,
      data: {
        'name': kyblspot.name,
        'location': serializeGeoPoint(kyblspot.location!),
        'description': kyblspot.description,
        'createdBy': kyblspot.createdBy,
        'weight': kyblspot.weight + 1,
        'rating': newRating,
      },
    );
  }

  Future<void> updateReview(
    SpotReviewModel review,
    KyblspotModel kyblspot,
    SpotReviewModel oldReview,
  ) async {
    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.kyblspotReviewsCollectionId,
      documentId: oldReview.reviewId,
      data: {
        'spotId': kyblspot.spotId,
        'reviewedByUid': review.reviewedByUid,
        'reviewedByProfilePic': review.reviewedByProfilePic,
        'reviewedByName': review.reviewedByName,
        'isPremium': review.isPremium,
        'review': review.review,
        'rating': review.rating,
      },
    );

    final newRating =
        ((kyblspot.weight - 1) * kyblspot.rating + review.rating) /
            kyblspot.weight;

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.kyblspotsCollectionId,
      documentId: kyblspot.spotId,
      data: {
        'name': kyblspot.name,
        'location': serializeGeoPoint(kyblspot.location!),
        'description': kyblspot.description,
        'createdBy': kyblspot.createdBy,
        'weight': kyblspot.weight,
        'rating': newRating,
      },
    );
  }

  Future<void> removeSpot(KyblspotModel kyblspot) async {
    final reviews = await _repository.listDocuments(
      AppwriteEnvironment.kyblspotReviewsCollectionId,
    );
    for (final review in reviews.where((review) => review['spotId'] == kyblspot.spotId)) {
      await _repository.deleteDocument(
        collectionId: AppwriteEnvironment.kyblspotReviewsCollectionId,
        documentId: review[r'$id'] as String,
      );
    }

    await _repository.deleteDocument(
      collectionId: AppwriteEnvironment.kyblspotsCollectionId,
      documentId: kyblspot.spotId,
    );
  }
}
