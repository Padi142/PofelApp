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
            reviewedByProfilePic: resolveStoredImageUrl(
              rawValue: doc['reviewedByProfilePic'],
              fallbackFileId: 'profile-${doc['reviewedByUid']}',
            ),
            rating: parseDouble(doc['rating']),
            reviewedByUid: doc['reviewedByUid'],
            reviewedByName: (doc['reviewedByName'] ?? '').toString(),
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
    final currentSpot = await _loadCurrentSpot(kyblspot);
    final reviewData = await _buildReviewData(review, kyblspot.spotId);
    await _repository.createDocument(
      collectionId: AppwriteEnvironment.kyblspotReviewsCollectionId,
      data: reviewData,
    );

    final newRating =
        (currentSpot.weight * currentSpot.rating + review.rating) /
            (currentSpot.weight + 1);

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.kyblspotsCollectionId,
      documentId: kyblspot.spotId,
      data: {
        'name': currentSpot.name,
        'location': serializeGeoPoint(currentSpot.location!),
        'description': currentSpot.description,
        'createdBy': currentSpot.createdBy,
        'weight': currentSpot.weight + 1,
        'rating': newRating,
      },
    );
  }

  Future<void> updateReview(
    SpotReviewModel review,
    KyblspotModel kyblspot,
    SpotReviewModel oldReview,
  ) async {
    final currentSpot = await _loadCurrentSpot(kyblspot);
    final reviewData = await _buildReviewData(review, kyblspot.spotId);
    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.kyblspotReviewsCollectionId,
      documentId: oldReview.reviewId,
      data: reviewData,
    );

    final newRating = ((currentSpot.weight * currentSpot.rating) -
            oldReview.rating +
            review.rating) /
        currentSpot.weight;

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.kyblspotsCollectionId,
      documentId: kyblspot.spotId,
      data: {
        'name': currentSpot.name,
        'location': serializeGeoPoint(currentSpot.location!),
        'description': currentSpot.description,
        'createdBy': currentSpot.createdBy,
        'weight': currentSpot.weight,
        'rating': newRating,
      },
    );
  }

  Future<void> removeReview(
    SpotReviewModel review,
    KyblspotModel kyblspot,
  ) async {
    final currentSpot = await _loadCurrentSpot(kyblspot);
    await _repository.deleteDocument(
      collectionId: AppwriteEnvironment.kyblspotReviewsCollectionId,
      documentId: review.reviewId,
    );

    final newWeight = currentSpot.weight > 0 ? currentSpot.weight - 1 : 0;
    final newRating = newWeight == 0
        ? 0.0
        : ((currentSpot.weight * currentSpot.rating) - review.rating) /
            newWeight;

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.kyblspotsCollectionId,
      documentId: kyblspot.spotId,
      data: {
        'name': currentSpot.name,
        'location': serializeGeoPoint(currentSpot.location!),
        'description': currentSpot.description,
        'createdBy': currentSpot.createdBy,
        'weight': newWeight,
        'rating': newRating,
      },
    );
  }

  Future<void> removeSpot(KyblspotModel kyblspot) async {
    final reviews = await _repository.listDocuments(
      AppwriteEnvironment.kyblspotReviewsCollectionId,
    );
    for (final review
        in reviews.where((review) => review['spotId'] == kyblspot.spotId)) {
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

  Future<Map<String, dynamic>> _buildReviewData(
    SpotReviewModel review,
    String spotId,
  ) async {
    final userDoc = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      review.reviewedByUid,
    );

    final reviewedByName =
        (userDoc?['name'] ?? review.reviewedByName).toString().trim();
    final reviewedByProfilePic = resolveStoredImageUrl(
      rawValue: userDoc?['profile_pic'] ?? review.reviewedByProfilePic,
      fallbackFileId: 'profile-${review.reviewedByUid}',
    );
    final isPremium = userDoc?['isPremium'] ?? review.isPremium;

    return {
      'spotId': spotId,
      'reviewedByUid': review.reviewedByUid,
      'reviewedByProfilePic': reviewedByProfilePic,
      'reviewedByName': reviewedByName.isEmpty ? 'Pofel user' : reviewedByName,
      'isPremium': isPremium,
      'review': review.review,
      'rating': review.rating,
    }..removeWhere((key, value) => value == null);
  }

  Future<KyblspotModel> _loadCurrentSpot(KyblspotModel fallback) async {
    final spotDoc = await _repository.getDocument(
      AppwriteEnvironment.kyblspotsCollectionId,
      fallback.spotId,
    );
    if (spotDoc == null) {
      return fallback;
    }

    return KyblspotModel(
      location: parseGeoPoint(spotDoc['location']),
      weight: parseInt(spotDoc['weight']),
      rating: parseDouble(spotDoc['rating']),
      name: spotDoc['name'],
      spotId: spotDoc[r'$id'] as String,
      createdBy: spotDoc['createdBy'],
      description: spotDoc['description'],
    );
  }
}
