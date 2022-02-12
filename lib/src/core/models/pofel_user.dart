import 'package:equatable/equatable.dart';

class PofelUserModel extends Equatable {
  const PofelUserModel({
    required this.uid,
    required this.name,
    required this.photo,
    required this.acceptedInvitation,
    required this.joinedOn,
  });

  final String uid;
  final String name;
  final String photo;
  final bool acceptedInvitation;
  final DateTime joinedOn;

  factory PofelUserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return PofelUserModel(
        uid: map["uid"],
        name: map["name"],
        photo: map["photo"],
        acceptedInvitation: map["acceptedInvitation"],
        joinedOn: map["joinedOn"]);
  }

  @override
  List<Object?> get props => [uid, name, photo, acceptedInvitation, joinedOn];
}

List<PofelUserModel> pofelUsersFromList(List<dynamic> list) {
  List<PofelUserModel> users = [];
  for (var user in list) {
    users.add(PofelUserModel.fromMap(user));
  }
  return users;
}
