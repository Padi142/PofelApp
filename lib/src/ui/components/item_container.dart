import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_event.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';

Widget itemContainer(
  BuildContext context,
  PofelModel pofel,
  ItemModel item,
  PofelItemsBloc itemBloc,
) {
  final style = _itemStyle(item.itemType);

  return GestureDetector(
    onTap: () => _showItemDetailsSheet(context, pofel, item, itemBloc),
    child: SizedBox(
      width: 176,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: style.color.withValues(alpha: 0.14),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: style.color.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
              color: PofelPalette.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: style.color,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${item.count}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                item.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: PofelPalette.text,
                ),
              ),
            ),
            if (item.price > 0)
              ...[
                const SizedBox(height: 10),
                Text(
                  '${item.price.toStringAsFixed(item.price % 1 == 0 ? 0 : 2)} Kč',
                  style: TextStyle(
                    color: style.color,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  foregroundImage: NetworkImage(item.addedByProfilePic),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.addedBy,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: PofelPalette.text.withValues(alpha: 0.72),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showItemDetailsSheet(
  BuildContext context,
  PofelModel pofel,
  ItemModel item,
  PofelItemsBloc itemBloc,
) {
  final style = _itemStyle(item.itemType);

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: style.icon,
      accentGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [style.color, PofelPalette.primary],
      ),
      title: item.name,
      subtitle: 'Detail itemu a rychlé akce k jeho správě.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ItemDetailRow(label: 'Typ', value: style.label),
          const SizedBox(height: 10),
          _ItemDetailRow(label: 'Počet', value: '${item.count}x'),
          const SizedBox(height: 10),
          _ItemDetailRow(
            label: 'Cena',
            value: item.price > 0
                ? '${item.price.toStringAsFixed(item.price % 1 == 0 ? 0 : 2)} Kč'
                : 'Nezadáno',
          ),
          const SizedBox(height: 10),
          _ItemDetailRow(label: 'Přidal', value: item.addedBy),
          const SizedBox(height: 10),
          _ItemDetailRow(
            label: 'Přidáno',
            value: DateFormat('dd.MM.  HH:mm').format(item.addedOn),
          ),
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zavřít',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel: 'Smazat item',
            primaryIcon: Icons.delete_outline_rounded,
            primaryGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFD1456E), Color(0xFFB32045)],
            ),
            onPrimary: () {
              itemBloc.add(
                DeleteItem(
                  uid: item.addedByUid,
                  addedOn: item.addedOn,
                  pofelId: pofel.pofelId,
                  adminUid: pofel.adminUid,
                ),
              );
              Navigator.pop(sheetContext);
            },
          ),
        ],
      ),
    ),
  );
}

class _ItemDetailRow extends StatelessWidget {
  const _ItemDetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: PofelPalette.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: PofelPalette.text.withValues(alpha: 0.56),
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: PofelPalette.text,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemVisualStyle {
  const _ItemVisualStyle({
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;
}

_ItemVisualStyle _itemStyle(ItemType type) {
  switch (type) {
    case ItemType.food:
      return const _ItemVisualStyle(
        color: Color(0xFFDA7A1F),
        icon: Icons.lunch_dining_rounded,
        label: 'Jídlo',
      );
    case ItemType.drink:
      return const _ItemVisualStyle(
        color: Color(0xFF2C82D8),
        icon: Icons.local_drink_rounded,
        label: 'Pití',
      );
    case ItemType.alcohol:
      return const _ItemVisualStyle(
        color: Color(0xFFB93B6A),
        icon: Icons.wine_bar_rounded,
        label: 'Alkohol',
      );
    case ItemType.drug:
      return const _ItemVisualStyle(
        color: Color(0xFF7B1BC5),
        icon: Icons.flare_rounded,
        label: 'Substance',
      );
    case ItemType.other:
      return const _ItemVisualStyle(
        color: Color(0xFF29956A),
        icon: Icons.category_rounded,
        label: 'Ostatní',
      );
  }
}
