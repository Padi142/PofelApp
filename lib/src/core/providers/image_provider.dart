import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pofel_app/src/core/models/pofel_image_model.dart';
import 'package:dio/dio.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';

class ImageProvider {
  Future<void> uploadPicture(
      String pofelId, XFile photo, PofelUserModel user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage storage = FirebaseStorage.instance;

    String imageName = DateTime.now().toString();

    Uint8List bytes = await photo.readAsBytes();

    Reference ref = storage.ref().child('pofel_media/$pofelId/$imageName.png');
    UploadTask uploadTask =
        ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print('image uploaded!'));

    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    await firestore
        .collection("active_pofels")
        .doc(pofelId)
        .collection("photos")
        .doc(imageName)
        .set({
      "photo": imageUrl,
      "name": imageName,
      "uploadedAt": DateTime.now(),
      "uploadedByName": user.name,
      "uploadedByUid": user.uid,
    });
  }

  Future<List<PofelImage>> fetchPhotos(String pofelId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<PofelImage> photos = [];

    var photoSnapshot = await firestore
        .collection("active_pofels")
        .doc(pofelId)
        .collection("photos")
        .get();
    if (photoSnapshot.docs.isNotEmpty) {
      photos = pofelPhotosFromList(photoSnapshot.docs);
    }

    return photos;
  }

  Future<void> downloadImage(String pofelId, PofelImage image) async {
    try {
      if (await Permission.storage.request().isGranted) {
        // await downloadToFile.create();
        var response = await Dio().get(image.photo,
            options: Options(responseType: ResponseType.bytes));
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
            quality: 100, name: "${image.name}");
      }
    } catch (e) {
      print(e);
    }
  }
}
