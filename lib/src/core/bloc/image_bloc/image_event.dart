import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';

import '../../models/pofel_image_model.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class UploadImages extends ImageEvent {
  final String pofelId;
  final PofelUserModel user;

  const UploadImages({required this.pofelId, required this.user});

  @override
  List<Object> get props => [pofelId];
}

class LoadImages extends ImageEvent {
  final String pofelId;

  const LoadImages({
    required this.pofelId,
  });

  @override
  List<Object> get props => [pofelId];
}

class DownloadImage extends ImageEvent {
  final String pofelId;
  final PofelImage image;

  const DownloadImage({
    required this.image,
    required this.pofelId,
  });

  @override
  List<Object> get props => [pofelId];
}
