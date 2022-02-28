import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/item_model.dart';

abstract class PofelItemsEvent extends Equatable {
  const PofelItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadPofelItems extends PofelItemsEvent {
  final String pofelId;
  const LoadPofelItems({required this.pofelId});

  @override
  List<Object> get props => [pofelId];
}

class AddPofelItem extends PofelItemsEvent {
  final String name;
  final String pofelId;
  final int count;
  final double price;
  final DateTime addedOn;
  final ItemType itemType;

  const AddPofelItem({
    required this.name,
    required this.pofelId,
    required this.count,
    required this.price,
    required this.addedOn,
    required this.itemType,
  });

  @override
  List<Object> get props => [name, pofelId, count, price, addedOn, itemType];
}

class DeleteItem extends PofelItemsEvent {
  final DateTime addedOn;
  final String pofelId;
  final String uid;
  final String adminUid;

  const DeleteItem(
      {required this.pofelId,
      required this.addedOn,
      required this.uid,
      required this.adminUid});

  @override
  List<Object> get props => [pofelId, addedOn, uid];
}
