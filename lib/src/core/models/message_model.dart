import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';

class MessageModel extends Equatable {
  const MessageModel({
    required this.message,
    required this.sentByName,
    required this.sentByProfilePic,
    required this.sentByUid,
    required this.sentOn,
  });

  final String message;
  final String sentByName;
  final String sentByProfilePic;
  final String sentByUid;
  final DateTime sentOn;

  @override
  List<Object?> get props => [];

  factory MessageModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MessageModel(
      message: map["message"],
      sentByName: map["sentByName"],
      sentByProfilePic: map["sentByProfilePic"],
      sentByUid: map["sentByUid"],
      sentOn: parseDateTime(map["sentOn"]),
    );
  }
}
