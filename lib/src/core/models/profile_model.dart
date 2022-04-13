import 'package:cloud_firestore/cloud_firestore.dart';
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
    QueryDocumentSnapshot<Object?> map,
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
    users.add(ProfileModel.fromMap(user));
  }
  return users;
}
