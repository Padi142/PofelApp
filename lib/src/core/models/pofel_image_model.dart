import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';

class PofelImage extends Equatable {
  const PofelImage({
    required this.uploadedByUid,
    required this.name,
    required this.uploadedByName,
    required this.uploadedAt,
    required this.photo,
  });

  final String uploadedByUid;
  final String uploadedByName;
  final String name;
  final String photo;
  final DateTime uploadedAt;

  factory PofelImage.fromMap(
    Map<String, dynamic> map,
  ) {
    return PofelImage(
      uploadedByUid: map["uploadedByUid"],
      uploadedByName: map["uploadedByName"],
      name: map["name"],
      photo: resolveStoredImageUrl(
        rawValue: map["photo"],
        fallbackFileId: map["fileId"] ?? map["name"],
      ),
      uploadedAt: parseDateTime(map["uploadedAt"]),
    );
  }

  @override
  List<Object?> get props => [
        uploadedByUid,
        uploadedByName,
        photo,
        uploadedAt,
      ];
}

List<PofelImage> pofelPhotosFromList(List<dynamic> list) {
  List<PofelImage> users = [];
  for (var user in list) {
    users.add(PofelImage.fromMap(Map<String, dynamic>.from(user)));
  }
  return users;
}
