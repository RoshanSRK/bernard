// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

Item itemFromJson(String str) => Item.fromJson(json.decode(str));

String itemToJson(Item data) => json.encode(data.toJson());

class Item {
  String id;
  String name;
  String? quantity;
  String? imageName;

  Item({
    required this.id,
    required this.name,
    this.quantity,
    this.imageName,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    quantity: json["quantity"],
    imageName: json["imageName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity": quantity,
    "imageName": imageName,
  };
}
