import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_bloc.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_event.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_state.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/pages/kyblspot_pages/kyblspot_set_location_page.dart';

class AddKyblPage extends StatefulWidget {
  AddKyblPage({Key? key}) : super(key: key);

  @override
  State<AddKyblPage> createState() => _AddKyblPageState();
}

class _AddKyblPageState extends State<AddKyblPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocListener<KyblCreationBloc, KyblCreationState>(
            listener: (context, state) {
              if (state is KyblspotCreationData) {
                if (state.mode == creationState.SUCCESFULY_ADDED) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarAlert(context, 'Úspěšně přidáno pooog'));
                }
              }
            },
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios)),
                        const Text("Tvorba kyblspotu",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 5),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Pojmenuj tohle epesní místečko",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                        ),
                        const SizedBox(height: 1),
                        FormBuilderTextField(
                          onChanged: ((value) => {
                                if (value!.length >= 3)
                                  {
                                    BlocProvider.of<KyblCreationBloc>(context)
                                        .add(AddKyblspotName(kyblName: value))
                                  }
                              }),
                          name: 'kyblspot_name',
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Popis kýblspotu',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Popiš Místečko",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                        ),
                        const SizedBox(height: 1),
                        FormBuilderTextField(
                          onChanged: ((value) => {
                                if (value!.length >= 3)
                                  {
                                    BlocProvider.of<KyblCreationBloc>(context)
                                        .add(AddKyblspotDesc(
                                      kyblDesc: value,
                                    ))
                                  }
                              }),
                          name: 'kyblspot_desc',
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText:
                                'Kde koupit chálky, vodu, jak to tam vypadá',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 5),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Vybrat súradnice",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17)),
                        ),
                        const SizedBox(height: 1),
                        BlocBuilder<KyblCreationBloc, KyblCreationState>(
                          builder: (context, state) {
                            if (state is KyblspotCreationData) {
                              if (state.mode ==
                                  creationState.POSITION_SPECIFIED) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                          state.position.latitude
                                                  .toString()
                                                  .substring(0, 8) +
                                              "  " +
                                              state.position.longitude
                                                  .toString()
                                                  .substring(0, 8),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17)),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      KyblspotSetLocationPage()),
                                            );
                                          },
                                          child: const Text(
                                            "Změnit",
                                            style: TextStyle(
                                                color: Color(0xFF8F3BB7)),
                                          ))
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  width: double.infinity,
                                  child: BlocBuilder<KyblCreationBloc,
                                      KyblCreationState>(
                                    builder: (context, state) {
                                      if (state is KyblspotCreationData) {
                                        if (state.mode ==
                                            creationState.NAME_DESC) {
                                          return OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        KyblspotSetLocationPage()),
                                              );
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Zadat místo',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF8F3BB7))),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF8F3BB7)),
                                            ),
                                          );
                                        } else {
                                          return OutlinedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBarError(
                                                      context,
                                                      'Vyplň nejdřív info o kýblu'));
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Zadat místo',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF8F3BB7))),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF8F3BB7)),
                                            ),
                                          );
                                        }
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                );
                              }
                            } else {
                              return Container();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 5),
                    child: SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<KyblCreationBloc, KyblCreationState>(
                        builder: (context, state) {
                          if (state is KyblspotCreationData) {
                            if (state.mode ==
                                creationState.POSITION_SPECIFIED) {
                              return ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<KyblCreationBloc>(context)
                                      .add(CreateKyblspot(state.name,
                                          state.description, state.position));
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Přidat kyblspot',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8F3BB7),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              );
                            } else {
                              return ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBarError(context,
                                          'Získej nejdřív souřadnice'));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Přidat kyblspot',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8F3BB7),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              );
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
