import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/bloc/image_bloc/image_event.dart';
import 'package:pofel_app/src/core/bloc/image_bloc/image_state.dart';
import 'package:pofel_app/src/core/models/pofel_image_model.dart';
import 'package:pofel_app/src/core/providers/image_provider.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc()
      : super(const ImageStateWithData(
            imageStateEnum: ImageStateEnum.NONE,
            uploaded: 0,
            totalToUpload: 0,
            photos: [])) {
    on<UploadImages>(_onUploadPictures);
    on<LoadImages>(_onLoadPhotos);
    on<DownloadImage>(_onDownloadImage);
  }
  ImageProvider imageProvider = ImageProvider();
  _onUploadPictures(UploadImages event, Emitter<ImageState> emit) async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      int uploadedIndex = 0;
      emit((state as ImageStateWithData).copyWith(
          imageStateEnum: ImageStateEnum.IMAGE_UPLOADING,
          totalToUpload: images.length,
          uploaded: 0));

      for (XFile image in images) {
        emit((state as ImageStateWithData).copyWith(
            imageStateEnum: ImageStateEnum.IMAGE_UPLOADING,
            uploaded: uploadedIndex));

        await imageProvider.uploadPicture(event.pofelId, image, event.user);
        uploadedIndex++;

        emit((state as ImageStateWithData).copyWith(
            imageStateEnum: ImageStateEnum.IMAGE_UPLOADED,
            uploaded: uploadedIndex));
      }
    }
    emit((state as ImageStateWithData).copyWith(
        imageStateEnum: ImageStateEnum.DONE_UPLOADIN, totalToUpload: 0));
  }

  _onLoadPhotos(LoadImages event, Emitter<ImageState> emit) async {
    List<PofelImage> photos = await imageProvider.fetchPhotos(event.pofelId);

    emit((state as ImageStateWithData).copyWith(
        photos: photos, imageStateEnum: ImageStateEnum.PHOTOS_LOADED));
  }

  _onDownloadImage(DownloadImage event, Emitter<ImageState> emit) async {
    await imageProvider.downloadImage(event.pofelId, event.image);

    emit((state as ImageStateWithData).copyWith());
  }
}
