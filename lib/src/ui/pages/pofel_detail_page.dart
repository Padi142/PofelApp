import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_info_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_signed_users.dart';

class PofelDetailPage extends StatefulWidget {
  PofelDetailPage({Key? key, required this.pofelId}) : super(key: key);
  final String pofelId;

  @override
  State<PofelDetailPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<PofelDetailPage> {
  @override
  Widget build(BuildContext context) {
    PofelDetailNavigationBloc _pofelBloc = PofelDetailNavigationBloc();
    _pofelBloc.add(const PofelInfoEvent());
    BlocProvider.of<PofelBloc>(context).add(LoadPofel(pofelId: widget.pofelId));

    return BlocProvider(
      create: (context) => _pofelBloc,
      child: BlocBuilder<PofelBloc, PofelState>(
        builder: (context, pofelState) {
          if (pofelState is PofelStateWithData &&
              pofelState.pofelStateEnum == PofelStateEnum.POFEL_LOADED) {
            return Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(pofelState.choosenPofel.name,
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Expanded(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _pofelBloc.add(PofelInfoEvent());
                                  },
                                  child: Text("Info"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _pofelBloc.add(PofelSignedUsersEvent());
                                  },
                                  child: Text("Users"),
                                )
                              ])),
                          Expanded(
                              flex: 7,
                              child: BlocBuilder<PofelDetailNavigationBloc,
                                  PofelNavigationState>(
                                builder: (context, state) {
                                  if (state is ShowPofelInfoState) {
                                    return PofelInfo(
                                        context, pofelState.choosenPofel);
                                  } else if (state is PofelSignedUsersState) {
                                    return PofelSignedUsers(
                                        context, pofelState.choosenPofel);
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ))
                        ],
                      ))
                ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
