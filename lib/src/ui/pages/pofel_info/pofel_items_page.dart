import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_state.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../components/item_container.dart';

Widget PofelItemsPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PofelItemsBloc _itemsBloc = PofelItemsBloc();
  _itemsBloc.add(LoadPofelItems(pofelId: pofel.pofelId));
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: BlocProvider(
      create: (context) => _itemsBloc,
      child: BlocListener<PofelItemsBloc, PofelItemsState>(
        listener: (context, state) {
          if (state is PofelItemsWithData) {
            switch (state.pofelItemsEnum) {
              case PofelItemsEnum.ITEM_ADDED:
                Future.delayed(const Duration(seconds: 5)).then((value) =>
                    _itemsBloc.add(LoadPofelItems(pofelId: pofel.pofelId)));
                break;
              case PofelItemsEnum.ITEM_REMOVED:
                Future.delayed(const Duration(seconds: 5)).then((value) =>
                    _itemsBloc.add(LoadPofelItems(pofelId: pofel.pofelId)));
                break;
              default:
                break;
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: BlocBuilder<PofelItemsBloc, PofelItemsState>(
                builder: (context, state) {
                  if (state is PofelItemsWithData) {
                    if (state.items.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Jídlo"),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.itemsByCategory[0].length,
                                    itemBuilder: (context, index) {
                                      return itemContainer(
                                          context,
                                          pofel,
                                          state.itemsByCategory[0][index],
                                          _itemsBloc);
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pití"),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.itemsByCategory[1].length,
                                    itemBuilder: (context, index) {
                                      return itemContainer(
                                          context,
                                          pofel,
                                          state.itemsByCategory[1][index],
                                          _itemsBloc);
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Alkohol"),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.itemsByCategory[2].length,
                                    itemBuilder: (context, index) {
                                      return itemContainer(
                                          context,
                                          pofel,
                                          state.itemsByCategory[2][index],
                                          _itemsBloc);
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pofel.showDrugItems
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Substance"),
                                      Expanded(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              state.itemsByCategory[3].length,
                                          itemBuilder: (context, index) {
                                            return itemContainer(
                                                context,
                                                pofel,
                                                state.itemsByCategory[3][index],
                                                _itemsBloc);
                                          },
                                          scrollDirection: Axis.horizontal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ostatní"),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.itemsByCategory[4].length,
                                    itemBuilder: (context, index) {
                                      return itemContainer(
                                          context,
                                          pofel,
                                          state.itemsByCategory[4][index],
                                          _itemsBloc);
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("Zatím tu nejsou žádné itemy :/"),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Alert(
                        context: context,
                        type: AlertType.none,
                        title: "Items",
                        content: Column(
                          children: [
                            ReactiveForm(
                              formGroup: form,
                              child: Column(
                                children: <Widget>[
                                  ReactiveTextField(
                                    formControlName: 'name',
                                    decoration: const InputDecoration(
                                      labelText: 'Jméno itemu',
                                    ),
                                    onSubmitted: () => form.focus('count'),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        backgroundColor: Colors.white),
                                  ),
                                  ReactiveTextField(
                                    formControlName: 'count',
                                    decoration: const InputDecoration(
                                      labelText: 'Počet',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: () => form.focus('type'),
                                  ),
                                  ReactiveDropdownField(
                                      formControlName: 'type',
                                      decoration: const InputDecoration(
                                        labelText: 'Typ',
                                      ),
                                      items: items),
                                  ReactiveTextField(
                                    formControlName: 'price',
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Cena (nepovinné)',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Přidat",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              if (form.control("name").value != "" &&
                                  form.control("count").value != "" &&
                                  form.control("type").value != "") {
                                _itemsBloc.add(AddPofelItem(
                                  name: form.control("name").value,
                                  count: int.parse(form.control("count").value),
                                  price: form.control("price").value != ""
                                      ? double.parse(
                                          form.control("price").value)
                                      : 0,
                                  itemType: getTypeFromString(
                                      form.control("type").value),
                                  addedOn: DateTime.now(),
                                  pofelId: pofel.pofelId,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBarAlert(context, 'Item přidán!'));
                                Navigator.pop(context);
                              }
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    },
                    child: const Text("Přidat item"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

final form = fb.group({
  'name': ['', Validators.required],
  'count': ['', Validators.required, Validators.number],
  'type': ["", Validators.required],
  'price': ['0'],
});
const List<DropdownMenuItem<String>> items = [
  DropdownMenuItem(
    child: Text('Jídlo (chálce)'),
    value: "food",
  ),
  DropdownMenuItem(
    child: Text('Pití'),
    value: "drink",
  ),
  DropdownMenuItem(
    child: Text('Alhohole'),
    value: "alcohol",
  ),
  DropdownMenuItem(
    child: Text('Substance'),
    value: "drug",
  ),
  DropdownMenuItem(
    child: Text('Ostatní'),
    value: "other",
  ),
];
