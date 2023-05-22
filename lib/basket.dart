// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';
import 'package:bernard/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  String id;
  String name;
  String? quantity;
  String imageName;
  String imageUrl;

  Item({
    required this.id,
    required this.name,
    this.quantity,
    required this.imageName,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        imageName: json["imageName"],
        imageUrl: '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "imageName": imageName,
        "imageUrl": imageUrl,
      };
}
