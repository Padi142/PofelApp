import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:pofel_app/src/core/models/pofel_image_model.dart';

part "image_state.g.dart";

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

@CopyWith()
class ImageStateWithData extends ImageState {
  final ImageStateEnum imageStateEnum;
  final int totalToUpload;
  final int uploaded;
  final List<PofelImage> photos;

  const ImageStateWithData(
      {required this.imageStateEnum,
      required this.totalToUpload,
      required this.photos,
      required this.uploaded});

  @override
  List<Object> get props => [imageStateEnum, totalToUpload, uploaded, photos];
}

enum ImageStateEnum {
  NONE,
  IMAGE_UPLOADING,
  IMAGE_UPLOADED,
  DONE_UPLOADIN,
  PHOTOS_LOADED
}
