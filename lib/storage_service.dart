import 'dart:io';
import 'dart:ui';
import 'package:bernard/basket.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return results;
  }

  Future<String> downloadURL(String imageName) async {
    print(imageName);
    String downloadURL = await storage.ref('test/$imageName').getDownloadURL();
    print(downloadURL);
    return downloadURL;
  }

  Future<List<Item>> assignURL(List<Item> items) async {
    String downloadUrl;
    String imageName;

    for (Item item in items) {
      imageName = item.imageName;
      // print(imageName);
      downloadUrl = await storage.ref('test/$imageName').getDownloadURL();
      // print(downloadURL);
      item.imageUrl = downloadUrl;
    }
    return items;
  }



  Future<List<String>> getDownloadURLs() async {
    List<String> downloadURLs = [];

    try {
      firebase_storage.ListResult results = await listFiles();

      for (firebase_storage.Reference ref in results.items) {
        String downloadimURL = await downloadURL(ref.name);
        downloadURLs.add(downloadimURL);
      }
    } catch (e) {
      print('Error occurred while fetching download URLs: $e');
    }

    return downloadURLs;
  }

}
