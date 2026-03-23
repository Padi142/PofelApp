import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_state.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import '../../components/item_container.dart';

Widget PofelItemsPage(BuildContext context, PofelModel pofel) {
  PofelItemsBloc itemsBloc = PofelItemsBloc();
  itemsBloc.add(LoadPofelItems(pofelId: pofel.pofelId));

  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
    child: BlocProvider(
      create: (context) => itemsBloc,
      child: BlocListener<PofelItemsBloc, PofelItemsState>(
        listener: (context, state) {
          if (state is PofelItemsWithData) {
            switch (state.pofelItemsEnum) {
              case PofelItemsEnum.ITEM_ADDED:
              case PofelItemsEnum.ITEM_REMOVED:
                Future.delayed(const Duration(seconds: 1)).then((_) {
                  itemsBloc.add(LoadPofelItems(pofelId: pofel.pofelId));
                });
                break;
              default:
                break;
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BlocBuilder<PofelItemsBloc, PofelItemsState>(
                builder: (context, state) {
                  if (state is! PofelItemsWithData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: PofelPalette.primary,
                      ),
                    );
                  }

                  final categories = _buildCategorySections(
                    state.itemsByCategory,
                    pofel.showDrugItems,
                  );

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (state.items.isEmpty)
                        const _InventoryEmptyState()
                      else
                        ...categories.map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _InventoryCategorySection(
                              category: category,
                              pofel: pofel,
                              itemsBloc: itemsBloc,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PofelOutlineButton(
                    label: 'Zpět',
                    onPressed: () {
                      context.read<PofelDetailNavigationBloc>().add(
                            const PofelInfoEvent(),
                          );
                    },
                    color: const Color(0xFFE59AA8),
                    textColor: const Color(0xFF7E2642),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PofelGradientButton(
                    label: 'Přidat item',
                    icon: Icons.add_shopping_cart_rounded,
                    onPressed: () {
                      _showAddItemSheet(context, pofel, itemsBloc);
                    },
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

class _InventoryStatsCard extends StatelessWidget {
  const _InventoryStatsCard({
    required this.totalItems,
    required this.activeCategories,
  });

  final int totalItems;
  final int activeCategories;

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: _StatPill(
              label: 'Celkem itemů',
              value: totalItems.toString(),
              color: PofelPalette.accentBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatPill(
              label: 'Aktivní kategorie',
              value: activeCategories.toString(),
              color: PofelPalette.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              color: PofelPalette.text.withValues(alpha: 0.66),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryEmptyState extends StatelessWidget {
  const _InventoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: PofelPalette.buttonGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.inventory_outlined,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Zatím tu nejsou žádné itemy',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: PofelPalette.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Přidej první věc, kterou někdo bere s sebou, a inventář se začne plnit.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: PofelPalette.text.withValues(alpha: 0.64),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryCategorySection extends StatelessWidget {
  const _InventoryCategorySection({
    required this.category,
    required this.pofel,
    required this.itemsBloc,
  });

  final _ItemCategoryViewModel category;
  final PofelModel pofel;
  final PofelItemsBloc itemsBloc;

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: PofelPalette.text,
                      ),
                    ),
                    Text(
                      category.subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PofelPalette.text.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${category.items.length}x',
                  style: GoogleFonts.nunito(
                    color: category.color,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (category.items.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: PofelPalette.background,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                category.emptyMessage,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: PofelPalette.text.withValues(alpha: 0.58),
                ),
              ),
            )
          else
            SizedBox(
              height: 182,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.fromLTRB(0, 2, 8, 6),
                itemCount: category.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return itemContainer(
                    context,
                    pofel,
                    category.items[index],
                    itemsBloc,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemCategoryViewModel {
  const _ItemCategoryViewModel({
    required this.title,
    required this.subtitle,
    required this.emptyMessage,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final String subtitle;
  final String emptyMessage;
  final IconData icon;
  final Color color;
  final List<ItemModel> items;
}

List<_ItemCategoryViewModel> _buildCategorySections(
  List<List<ItemModel>> itemsByCategory,
  bool showDrugItems,
) {
  final categories = <_ItemCategoryViewModel>[
    _ItemCategoryViewModel(
      title: 'Jídlo',
      subtitle: 'Chálka na rozjezd i dojezd.',
      emptyMessage: 'Nikdo ještě nepřidal žádné jídlo.',
      icon: Icons.lunch_dining_rounded,
      color: const Color(0xFFDA7A1F),
      items: itemsByCategory.isNotEmpty ? itemsByCategory[0] : const [],
    ),
    _ItemCategoryViewModel(
      title: 'Pití',
      subtitle: 'Voda, limo i všechno na žízeň.',
      emptyMessage: 'Sekce pití je zatím prázdná.',
      icon: Icons.local_drink_rounded,
      color: const Color(0xFF2C82D8),
      items: itemsByCategory.length > 1 ? itemsByCategory[1] : const [],
    ),
    _ItemCategoryViewModel(
      title: 'Alkohol',
      subtitle: 'Všechno, co dává vibe večera.',
      emptyMessage: 'Alkohol zatím nikdo nenahlásil.',
      icon: Icons.wine_bar_rounded,
      color: const Color(0xFFB93B6A),
      items: itemsByCategory.length > 2 ? itemsByCategory[2] : const [],
    ),
  ];

  if (showDrugItems) {
    categories.add(
      _ItemCategoryViewModel(
        title: 'Substance',
        subtitle: 'Skrytá sekce jen pokud je povolená.',
        emptyMessage: 'Tady zatím nic není.',
        icon: Icons.flare_rounded,
        color: const Color(0xFF7B1BC5),
        items: itemsByCategory.length > 3 ? itemsByCategory[3] : const [],
      ),
    );
  }

  categories.add(
    _ItemCategoryViewModel(
      title: 'Ostatní',
      subtitle: 'Kabely, reprák, hry a všechno navíc.',
      emptyMessage: 'Do ostatních věcí ještě nikdo nic nepřidal.',
      icon: Icons.category_rounded,
      color: const Color(0xFF29956A),
      items: itemsByCategory.length > 4 ? itemsByCategory[4] : const [],
    ),
  );

  return categories;
}

const List<DropdownMenuItem<String>> items = [
  DropdownMenuItem(value: "food", child: Text('Jídlo (chálce)')),
  DropdownMenuItem(value: "drink", child: Text('Pití')),
  DropdownMenuItem(value: "alcohol", child: Text('Alkohol')),
  DropdownMenuItem(value: "drug", child: Text('Substance')),
  DropdownMenuItem(value: "other", child: Text('Ostatní')),
];

Future<void> _showAddItemSheet(
  BuildContext context,
  PofelModel pofel,
  PofelItemsBloc itemsBloc,
) {
  final form = fb.group(<String, Object>{
    'name': FormControl<String>(validators: [Validators.required]),
    'count': FormControl<String>(
      validators: [Validators.required, Validators.number()],
    ),
    'type': FormControl<String>(validators: [Validators.required]),
    'price': FormControl<String>(value: ''),
  });

  return showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.inventory_2_rounded,
      title: 'Přidat item',
      subtitle: 'Dej ostatním vědět co bereš s sebou',
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReactiveTextField<String>(
              formControlName: 'name',
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validationMessages: {
                ValidationMessage.required: (_) => 'Doplň název itemu.',
              },
              decoration: pofelModalInputDecoration(
                labelText: 'Jméno itemu',
                hintText: 'Např. Led, pivo, chipsy...',
                prefixIcon: Icons.sell_rounded,
              ),
              onSubmitted: (_) => form.focus('count'),
            ),
            const SizedBox(height: 12),
            ReactiveTextField<String>(
              formControlName: 'count',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validationMessages: {
                ValidationMessage.required: (_) => 'Doplň počet.',
                ValidationMessage.number: (_) => 'Počet musí být číslo.',
              },
              decoration: pofelModalInputDecoration(
                labelText: 'Počet',
                hintText: 'Kolik kusů bereš?',
                prefixIcon: Icons.onetwothree_rounded,
              ),
              onSubmitted: (_) => form.focus('type'),
            ),
            const SizedBox(height: 12),
            ReactiveDropdownField<String>(
              formControlName: 'type',
              validationMessages: {
                ValidationMessage.required: (_) => 'Vyber typ itemu.',
              },
              decoration: pofelModalInputDecoration(
                labelText: 'Typ',
                hintText: 'Kategorie itemu',
                prefixIcon: Icons.category_rounded,
              ),
              items: items,
            ),
            const SizedBox(height: 12),
            ReactiveTextField<String>(
              formControlName: 'price',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              validationMessages: {
                ValidationMessage.number: (_) => 'Cena musí být číslo.',
              },
              decoration: pofelModalInputDecoration(
                labelText: 'Cena',
                hintText: 'Nepovinné',
                prefixIcon: Icons.payments_rounded,
                helperText: 'Nech prázdné, pokud cenu nechceš řešit.',
              ),
            ),
            const SizedBox(height: 20),
            PofelModalActions(
              secondaryLabel: 'Zrušit',
              onSecondary: () => Navigator.pop(sheetContext),
              primaryLabel: 'Přidat item',
              primaryIcon: Icons.add_rounded,
              onPrimary: () {
                if (!form.valid) {
                  form.markAllAsTouched();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarError(
                      context,
                      'Zkontroluj prosím zvýrazněná pole.',
                    ),
                  );
                  return;
                }

                final name = (form.control('name').value as String?)?.trim() ?? '';
                final count = int.tryParse(
                  (form.control('count').value as String?)?.trim() ?? '',
                );
                final priceRaw = (form.control('price').value as String?)?.trim() ?? '';
                final price = priceRaw.isEmpty ? 0.0 : double.tryParse(priceRaw);
                final type = form.control('type').value as String?;

                if (name.isEmpty || count == null || type == null || type.isEmpty) {
                  form.markAllAsTouched();
                  return;
                }
                if (price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarError(context, 'Cena musí být validní číslo.'),
                  );
                  return;
                }

                itemsBloc.add(
                  AddPofelItem(
                    name: name,
                    count: count,
                    price: price,
                    itemType: getTypeFromString(type),
                    addedOn: DateTime.now(),
                    pofelId: pofel.pofelId,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarAlert(context, 'Item přidán!'),
                );
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
