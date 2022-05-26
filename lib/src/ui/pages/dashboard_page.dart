import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_event.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_state.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:pofel_app/src/ui/components/gradient_button.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/pages/public_pofels_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../core/bloc/pofel_bloc/pofel_bloc.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoadpofelsBloc>(context).add(LoadMyPofels());
    return BlocListener<PofelBloc, PofelState>(
      listener: (context, state) {
        if (state is PofelStateWithData) {
          switch (state.pofelStateEnum) {
            case PofelStateEnum.POFEL_CREATED:
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarAlert(context, 'Pofel úspěšně vytvořen'));
              Future.delayed(const Duration(seconds: 5)).then((value) =>
                  BlocProvider.of<LoadpofelsBloc>(context)
                      .add(const LoadMyPofels()));
              break;
            case PofelStateEnum.POFEL_JOINED:
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarAlert(context, 'Úspěšně připojeno k pofelu'));
              Future.delayed(const Duration(seconds: 2)).then((value) =>
                  BlocProvider.of<LoadpofelsBloc>(context)
                      .add(const LoadMyPofels()));
              break;
            case PofelStateEnum.ERROR_JOINING:
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBarError(context, state.errorMessage!));
              break;
            default:
              break;
          }
        }
      },
      child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 30, right: 30),
                  child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF0066C3),
                              Color(0xFF7D00A9),
                            ],
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Moje pofely",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          BlocBuilder<LoadpofelsBloc, LoadpofelsState>(
                            builder: (context, state) {
                              if (state is LoadPofelsWithData) {
                                if (state.loadPofelStateEnum ==
                                    LoadPofelsStateEnum.POFELS_LOADED) {
                                  if (state.myPofels.isNotEmpty) {
                                    return Expanded(
                                      child: ListView.builder(
                                          itemCount: state.myPofels.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: GestureDetector(
                                                onTap: () {
                                                  BlocProvider.of<
                                                              NavigationBloc>(
                                                          context)
                                                      .add(PofelDetailPageEvent(
                                                    pofelId: state
                                                        .myPofels[index]
                                                        .pofelId,
                                                  ));
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              Color(0xFF73BCFC),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: InkWell(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            state
                                                                .myPofels[index]
                                                                .name,
                                                            style: const TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                  "za: "),
                                                              Text(
                                                                daysBetween(
                                                                        DateTime
                                                                            .now(),
                                                                        state
                                                                            .myPofels[index]
                                                                            .dateFrom!)
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              const Text(
                                                                  " dní"),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    );
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Center(
                                          child: Text(
                                        "Žadny pofer 😢😟 ",
                                        style: TextStyle(fontSize: 17),
                                      )),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          OutlinedButton(
                            onPressed: () {
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(const LoadPublicPofelPage());
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Veřejné pofely",
                                style: TextStyle(
                                    color: Color(0xFF7D00A9),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              side: const BorderSide(
                                  width: 5.0, color: Color(0xFF7D00A9)),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      )),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
              child: GradientButton(
                buttonText: "Připojit k pofelu",
                onpressed: () {
                  Alert(
                    context: context,
                    type: AlertType.none,
                    title: "Připojit k pofelu",
                    desc: "Zadejte pofel join ID",
                    content: Column(
                      children: [
                        TextField(
                          controller: myController,
                          decoration: const InputDecoration(),
                        ),
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        child: const Text(
                          "Join",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          BlocProvider.of<PofelBloc>(context)
                              .add(JoinPofel(joinId: myController.text));
                          BlocProvider.of<LoadpofelsBloc>(context)
                              .add(const LoadMyPofels());
                          Navigator.pop(context);
                        },
                        width: 120,
                      )
                    ],
                  ).show();
                },
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 60, right: 60),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    DateTime pickedDate = DateTime.utc(1989, 11, 9);
                    Alert(
                      context: context,
                      type: AlertType.none,
                      title: "Zadejte jméno pofelu a datum",
                      content: Column(
                        children: [
                          TextField(
                            controller: myController,
                            decoration:
                                const InputDecoration(labelText: "Jméno"),
                          ),
                          const SizedBox(height: 5),
                          DateTimePicker(
                              type: DateTimePickerType.dateTime,
                              initialValue: '',
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              dateLabelText: 'Datum a čas',
                              onChanged: (val) {
                                pickedDate = DateTime.parse(val);
                              })
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          child: const Text(
                            "Create",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            if (pickedDate != DateTime.utc(1989, 11, 9)) {
                              BlocProvider.of<PofelBloc>(context).add(
                                  CreatePofel(
                                      pofelDesc: 'Žádný popis :/',
                                      pofelName: myController.text,
                                      date: pickedDate));
                              Navigator.pop(context);
                            }
                          },
                          width: 120,
                        )
                      ],
                    ).show();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Vytvořit pofel",
                      style: TextStyle(
                          color: Color(0xFF7D00A9),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    side:
                        const BorderSide(width: 5.0, color: Color(0xFF7D00A9)),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    return (to.difference(from).inDays);
  }
}
