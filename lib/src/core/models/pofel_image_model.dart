import 'package:equatable/equatable.dart';

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
      photo: map["photo"],
      uploadedAt: map["uploadedAt"].toDate(),
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
    users.add(PofelImage.fromMap(user.data()));
  }
  return users;
}
