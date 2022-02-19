import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_state.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/pofel_items_provider.dart';
import '../../providers/pofel_provider.dart';

class PofelItemsBloc extends Bloc<PofelItemsEvent, PofelItemsState> {
  PofelItemsBloc()
      : super(const PofelItemsWithData(
            pofelItemsEnum: PofelItemsEnum.INITIAL,
            itemsByCategory: [],
            items: [])) {
    on<LoadPofelItems>(_onLoadPofels);
    on<AddPofelItem>(_onAddItem);
    on<DeleteItem>(_onDeleteItem);
  }
  ItemsProvider itemsApiProvider = ItemsProvider();
  _onLoadPofels(LoadPofelItems event, Emitter<PofelItemsState> emit) async {
    List<ItemModel> items =
        await itemsApiProvider.fetchPofelItems(event.pofelId);

    if (items.isNotEmpty) {
      List<List<ItemModel>> types = itemsByItemType(items);
      emit((state as PofelItemsWithData).copyWith(
          itemsByCategory: types,
          items: items,
          pofelItemsEnum: PofelItemsEnum.ITEMS_LOADED));
    } else {
      emit((state as PofelItemsWithData)
          .copyWith(pofelItemsEnum: PofelItemsEnum.ITEMS_EMPTY));
    }
  }

  _onAddItem(AddPofelItem event, Emitter<PofelItemsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    itemsApiProvider.addItem(event.pofelId, uid, event.name, event.count,
        event.price, DateTime.now(), event.itemType);
    emit((state as PofelItemsWithData)
        .copyWith(pofelItemsEnum: PofelItemsEnum.ITEM_ADDED));
  }

  _onDeleteItem(DeleteItem event, Emitter<PofelItemsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if (uid == event.uid) {
      itemsApiProvider.removeItem(event.pofelId, event.addedOn);

      emit((state as PofelItemsWithData)
          .copyWith(pofelItemsEnum: PofelItemsEnum.ITEM_REMOVED));
    }
  }
}
