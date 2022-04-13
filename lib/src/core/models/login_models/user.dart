import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    this.following,
    this.followers,
    this.email,
    this.name,
    this.photo,
    this.isPremium,
  });

  final String? email;
  final String uid;
  final List<ProfileModel>? followers;
  final List<ProfileModel>? following;
  final String? name;
  final String? photo;
  final bool? isPremium;

  static const empty = UserModel(uid: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserModel.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserModel.empty;

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      uid: map["uid"],
      name: map["name"],
      photo: map["profile_pic"],
      isPremium: map["isPremium"],
    );
  }

  @override
  List<Object?> get props => [email, uid, name, photo];
}

List<UserModel> usersFromList(List<dynamic> list) {
  List<UserModel> users = [];
  for (var user in list) {
    users.add(UserModel.fromMap(user));
  }
  return users;
}
