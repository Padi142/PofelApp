import 'package:cloud_firestore/cloud_firestore.dart';

class KyblspotModel {
  final String name;
  final String description;
  final String spotId;
  final String createdBy;
  final GeoPoint? location;
  final int weight;
  final double rating;

  KyblspotModel({
    required this.name,
    required this.description,
    required this.spotId,
    required this.createdBy,
    required this.location,
    required this.weight,
    required this.rating,
  });
}
