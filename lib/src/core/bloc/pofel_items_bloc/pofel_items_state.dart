import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';

part "pofel_items_state.g.dart";

abstract class PofelItemsState extends Equatable {
  const PofelItemsState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class PofelItemsWithData extends PofelItemsState {
  final List<ItemModel> items;
  final List<List<ItemModel>> itemsByCategory;
  final PofelItemsEnum pofelItemsEnum;
  const PofelItemsWithData(
      {required this.items,
      required this.pofelItemsEnum,
      required this.itemsByCategory});

  @override
  List<Object> get props => [items, pofelItemsEnum, itemsByCategory];
}

enum PofelItemsEnum {
  INITIAL,
  ITEMS_EMPTY,
  ITEMS_LOADED,
  ITEM_ADDED,
  ITEM_REMOVED
}
