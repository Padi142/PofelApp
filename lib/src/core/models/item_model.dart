import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  const ItemModel({
    required this.name,
    required this.count,
    required this.price,
    required this.addedBy,
    required this.addedByUid,
    required this.addedByProfilePic,
    required this.addedOn,
    required this.itemType,
  });

  final String name;
  final int count;
  final double price;
  final String addedBy;
  final String addedByUid;
  final String addedByProfilePic;
  final DateTime addedOn;
  final ItemType itemType;

  @override
  List<Object?> get props => [];

  factory ItemModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ItemModel(
      name: map["name"],
      count: map["count"],
      price: map["price"],
      addedBy: map["addedBy"],
      addedByUid: map["addedByUid"],
      addedByProfilePic: map["addedByProfilePic"],
      addedOn: map["addedOn"].toDate(),
      itemType: getTypeFromString(map["itemType"]),
    );
  }
}

enum ItemType { food, drink, alcohol, drug, other }

ItemType getTypeFromString(String type) {
  switch (type) {
    case "food":
      return ItemType.food;
    case "drink":
      return ItemType.drink;
    case "alcohol":
      return ItemType.alcohol;
    case "drug":
      return ItemType.drug;
    case "other":
      return ItemType.other;
    default:
      return ItemType.other;
  }
}

String getStringFromType(ItemType type) {
  switch (type) {
    case ItemType.food:
      return "food";
    case ItemType.drink:
      return "drink";
    case ItemType.alcohol:
      return "alcohol";
    case ItemType.drug:
      return "drug";
    case ItemType.other:
      return "other";
    default:
      return "other";
  }
}

List<ItemModel> pofelUsersFromList(List<dynamic> list) {
  List<ItemModel> users = [];
  for (var item in list) {
    users.add(ItemModel.fromMap(item.data()));
  }
  return users;
}

List<List<ItemModel>> itemsByItemType(List<ItemModel> items) {
  List<ItemModel> food = [];
  List<ItemModel> drink = [];
  List<ItemModel> alcohol = [];
  List<ItemModel> drug = [];
  List<ItemModel> other = [];
  for (ItemModel item in items) {
    switch (item.itemType) {
      case ItemType.food:
        food.add(item);
        break;
      case ItemType.drink:
        drink.add(item);
        break;
      case ItemType.alcohol:
        alcohol.add(item);
        break;
      case ItemType.drug:
        drug.add(item);
        break;
      case ItemType.other:
        other.add(item);
        break;
      default:
        other.add(item);
        break;
    }
  }
  List<List<ItemModel>> types = [food, drink, alcohol, drug, other];
  return types;
}
