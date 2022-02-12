import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    this.email,
    this.name,
    this.photo,
  });

  final String? email;
  final String uid;
  final String? name;
  final String? photo;

  static const empty = UserModel(uid: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserModel.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserModel.empty;

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(uid: map["uid"], name: map["name"], photo: map["photo"]);
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
