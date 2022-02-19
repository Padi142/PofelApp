// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pofel_items_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PofelItemsWithDataCWProxy {
  PofelItemsWithData items(List<ItemModel> items);

  PofelItemsWithData itemsByCategory(List<List<ItemModel>> itemsByCategory);

  PofelItemsWithData pofelItemsEnum(PofelItemsEnum pofelItemsEnum);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PofelItemsWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PofelItemsWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  PofelItemsWithData call({
    List<ItemModel>? items,
    List<List<ItemModel>>? itemsByCategory,
    PofelItemsEnum? pofelItemsEnum,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPofelItemsWithData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPofelItemsWithData.copyWith.fieldName(...)`
class _$PofelItemsWithDataCWProxyImpl implements _$PofelItemsWithDataCWProxy {
  final PofelItemsWithData _value;

  const _$PofelItemsWithDataCWProxyImpl(this._value);

  @override
  PofelItemsWithData items(List<ItemModel> items) => this(items: items);

  @override
  PofelItemsWithData itemsByCategory(List<List<ItemModel>> itemsByCategory) =>
      this(itemsByCategory: itemsByCategory);

  @override
  PofelItemsWithData pofelItemsEnum(PofelItemsEnum pofelItemsEnum) =>
      this(pofelItemsEnum: pofelItemsEnum);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PofelItemsWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PofelItemsWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  PofelItemsWithData call({
    Object? items = const $CopyWithPlaceholder(),
    Object? itemsByCategory = const $CopyWithPlaceholder(),
    Object? pofelItemsEnum = const $CopyWithPlaceholder(),
  }) {
    return PofelItemsWithData(
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ItemModel>,
      itemsByCategory: itemsByCategory == const $CopyWithPlaceholder() ||
              itemsByCategory == null
          ? _value.itemsByCategory
          // ignore: cast_nullable_to_non_nullable
          : itemsByCategory as List<List<ItemModel>>,
      pofelItemsEnum: pofelItemsEnum == const $CopyWithPlaceholder() ||
              pofelItemsEnum == null
          ? _value.pofelItemsEnum
          // ignore: cast_nullable_to_non_nullable
          : pofelItemsEnum as PofelItemsEnum,
    );
  }
}

extension $PofelItemsWithDataCopyWith on PofelItemsWithData {
  /// Returns a callable class that can be used as follows: `instanceOfclass PofelItemsWithData extends PofelItemsState.name.copyWith(...)` or like so:`instanceOfclass PofelItemsWithData extends PofelItemsState.name.copyWith.fieldName(...)`.
  _$PofelItemsWithDataCWProxy get copyWith =>
      _$PofelItemsWithDataCWProxyImpl(this);
}
