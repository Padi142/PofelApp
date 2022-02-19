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
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../core/bloc/pofel_bloc/pofel_bloc.dart';

class PofelListPage extends StatefulWidget {
  PofelListPage({Key? key}) : super(key: key);

  @override
  State<PofelListPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<PofelListPage> {
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
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<NavigationBloc>(context)
                                      .add(PofelDetailPageEvent(
                                    state.myPofels[index].pofelId,
                                  ));
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF73BCFC),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
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
                                              const Text("za: "),
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
