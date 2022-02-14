import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';

part "loadpofels_state.g.dart";

abstract class LoadpofelsState extends Equatable {
  const LoadpofelsState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class LoadPofelsWithData extends LoadpofelsState {
  final List<PofelModel> myPofels;
  final LoadPofelsStateEnum loadPofelStateEnum;
  const LoadPofelsWithData(
      {required this.myPofels, required this.loadPofelStateEnum});

  @override
  List<Object> get props => [myPofels, loadPofelStateEnum];
}

enum LoadPofelsStateEnum { INITIAL, POFELS_EMPTY, POFELS_LOADED }
