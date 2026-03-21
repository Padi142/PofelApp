import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.uid,
    required this.name,
    required this.photo,
    required this.isPremium,
  });

  final String uid;
  final String name;
  final String photo;
  final bool isPremium;

  factory ProfileModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProfileModel(
        uid: map["uid"],
        name: map["name"],
        photo: map["profile_pic"],
        //isPremium: map["isPremium"],
        isPremium: false);
  }

  @override
  List<Object?> get props => [uid, name, photo];
}

List<ProfileModel> profilesFromList(List<dynamic> list) {
  List<ProfileModel> users = [];
  for (var user in list) {
    try {
      users.add(ProfileModel.fromMap(Map<String, dynamic>.from(user)));
    } catch (e) {
      users.add(ProfileModel(
          uid: user["uid"],
          name: "Jmeno neni dostupné",
          photo:
              "https://thumbs.dreamstime.com/b/no-image-available-icon-photo-camera-flat-vector-illustration-132483141.jpg",
          //isPremium: map["isPremium"],
          isPremium: false));
    }
  }
  return users;
}
