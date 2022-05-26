import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pofel_app/src/core/models/public_pofel_model.dart';

part "public_pofel_state.g.dart";

abstract class PublicPofelState extends Equatable {
  const PublicPofelState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class PublicPofelsLoaded extends PublicPofelState {
  final List<PublicPofelModel> pofels;
  final List<Marker> markers;
  final PublicPofelEnum publicPofelEnum;

  const PublicPofelsLoaded({
    required this.pofels,
    required this.publicPofelEnum,
    required this.markers,
  });

  @override
  List<Object> get props => [pofels, markers, publicPofelEnum];
}

enum PublicPofelEnum { LOADING, LOADED, NONE }
