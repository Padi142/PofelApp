import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';

class PofelUserModel extends Equatable {
  const PofelUserModel({
    required this.uid,
    required this.name,
    required this.willArrive,
    required this.photo,
    required this.acceptedInvitation,
    required this.joinedOn,
    required this.chatNotification,
    required this.isPremium,
  });

  final String uid;
  final String name;
  final String photo;
  final bool acceptedInvitation;
  final DateTime joinedOn;
  final DateTime willArrive;
  final bool chatNotification;
  final bool isPremium;

  factory PofelUserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return PofelUserModel(
      uid: map["uid"],
      name: map["name"],
      photo: resolveStoredImageUrl(
        rawValue: map["profile_pic"],
        fallbackFileId: 'profile-${map["uid"]}',
      ),
      acceptedInvitation: parseBool(map["acceptedInvitation"]),
      joinedOn: parseDateTime(map["signedOn"]),
      willArrive: parseDateTime(map["willArrive"]),
      chatNotification: map["chatNotification"] ?? true,
      isPremium: map["isPremium"] ?? false,
    );
  }

  @override
  List<Object?> get props => [uid, name, photo, acceptedInvitation, joinedOn];
}

List<PofelUserModel> pofelUsersFromList(List<dynamic> list) {
  List<PofelUserModel> users = [];
  for (var user in list) {
    users.add(PofelUserModel.fromMap(Map<String, dynamic>.from(user)));
  }
  return users;
}
