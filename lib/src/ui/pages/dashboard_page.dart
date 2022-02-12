import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_event.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_state.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
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
    return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: (Text("Moje pofely: ",
                  style: TextStyle(color: Colors.black87, fontSize: 17))),
            ),
          ),
          Expanded(
              flex: 3,
              child: BlocBuilder<LoadpofelsBloc, LoadpofelsState>(
                builder: (context, state) {
                  if (state is LoadPofelsWithData) {
                    if (state.loadPofelStateEnum ==
                        LoadPofelsStateEnum.POFELS_LOADED) {
                      return ListView.builder(
                          itemCount: state.myPofels.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                color: Colors.blueAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state.myPofels[index].name,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            const Text("Pofel proběhne za: "),
                                            Text(
                                              daysBetween(
                                                      DateTime.now(),
                                                      state.myPofels[index]
                                                          .dateFrom!)
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            const Text(" dní"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
              )),
          const Divider(
            color: Colors.grey,
          ),
          Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          type: AlertType.none,
                          title: "Připojit k pofelu",
                          desc: "Zadejte pofel join ID",
                          content: Column(
                            children: [
                              TextField(
                                controller: myController,
                                obscureText: true,
                                decoration: const InputDecoration(),
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              child: const Text(
                                "Join",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                BlocProvider.of<PofelBloc>(context)
                                    .add(JoinPofel(joinId: myController.text));
                                Navigator.pop(context);
                              },
                              width: 120,
                            )
                          ],
                        ).show();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Připojit se k pofelu',
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F3BB7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("nebo",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<PofelBloc>(context).add(
                            CreatePofel(pofelDesc: 'test', pofelName: 'test'));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Vytvořit pofel',
                            style: TextStyle(
                                color: Color(0xFF8F3BB7), fontSize: 18)),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        side: const BorderSide(
                            width: 1, color: Color(0xFF8F3BB7)),
                      ),
                    ),
                  ],
                ),
              ))
        ]);
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
