import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';

class PofelModel extends Equatable {
  const PofelModel({
    required this.name,
    required this.description,
    required this.adminUid,
    this.dateFrom,
    this.dateTo,
    required this.pofelId,
    required this.createdAt,
    required this.joinCode,
    required this.signedUsers,
  });

  final String name;
  final String description;
  final String pofelId;
  final String joinCode;
  final String adminUid;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final DateTime? createdAt;
  final List<PofelUserModel> signedUsers;

  @override
  List<Object?> get props => [pofelId];

  static const empty = PofelModel(
    adminUid: '',
    description: '',
    joinCode: '',
    name: '',
    pofelId: '',
    signedUsers: [],
    createdAt: null,
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == PofelModel.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != PofelModel.empty;
}
