import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class ImageServices {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //Add images in Storage and return list strings
  Future<List<String>> addImagesAndReturnStrings(List<File> imageFiles) async {
    List<String> imagesUrl = [];
    print(imageFiles.length);
    for (int i = 0; i < imageFiles.length; i++) {
      String imageUrl = await addImageAndReturnString(imageFiles[i]);
      imagesUrl.add(imageUrl);
    }

    return imagesUrl;
  }

  //Add images in Storage and return list strings
  Future<String> addImageAndReturnString(File? imageFile) async {
    String imageUrl = "";
    Random random = new Random();
    int randomNumber = random.nextInt(10000) + random.nextInt(10000);
    String datetime =
        DateFormat('dd_MM_yyyy hh_mm_ss').format(DateTime.now()).toString() +
            "_" +
            randomNumber.toString();
    firebase_storage.Reference ref = storage.ref().child('Image/${datetime}');
    firebase_storage.UploadTask uploadTask = ref.putFile(imageFile!);
    await uploadTask.whenComplete(() async {
      String url = await ref.getDownloadURL();
      if (url != "") {
        imageUrl = url;
      }
    });

    return imageUrl;
  }

  List<File> convertAssetListToFileList(List<Asset> assets) {
    List<File> files = [];
    assets.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);

      if (tempFile.existsSync()) {
        files.add(tempFile);
      }
    });
    return files;
  }
}
