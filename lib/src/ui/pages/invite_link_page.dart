import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import 'package:pofel_app/src/ui/components/gradient_button.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_info_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_items_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_settings_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_signed_users.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_user_settings_page.dart';

class InviteLinkPage extends StatefulWidget {
  const InviteLinkPage({Key? key, required this.joinId}) : super(key: key);
  final String joinId;

  @override
  State<InviteLinkPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<InviteLinkPage> {
  @override
  Widget build(BuildContext context) {
    PofelDetailNavigationBloc _pofelBloc = PofelDetailNavigationBloc();
    _pofelBloc.add(const PofelInfoEvent());
    BlocProvider.of<PofelBloc>(context)
        .add(LoadPofelByJoinId(joinId: widget.joinId));

    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
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
                      Container(
                        margin: const EdgeInsets.all(6),
                        child: const Text("Byl jsi pozván na pofel:",
                            style:
                                TextStyle(color: Colors.black, fontSize: 24)),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF0066C3),
                                  Color(0xFF7D00A9),
                                ],
                              )),
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(pofelState.choosenPofel.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            const Text("Datum: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Text(
                                                DateFormat('dd.MM. – kk:mm')
                                                    .format(pofelState
                                                        .choosenPofel
                                                        .dateFrom!),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            const Text("Účastníků: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Text(
                                                pofelState.choosenPofel
                                                    .signedUsers.length
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    const Text(
                                      "Uživatelé na pofelu:",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: pofelState
                                            .choosenPofel.signedUsers.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              margin: const EdgeInsets.all(2),
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 170, 57, 170),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        child: Text(
                                                            pofelState
                                                                .choosenPofel
                                                                .signedUsers[
                                                                    index]
                                                                .name,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Image.network(
                                                            pofelState
                                                                .choosenPofel
                                                                .signedUsers[
                                                                    index]
                                                                .photo,
                                                            height: 50,
                                                            width: 50),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GradientButton(
                          buttonText: "Přijmou pozvánku",
                          onpressed: () {
                            BlocProvider.of<PofelBloc>(context)
                                .add(JoinPofel(joinId: widget.joinId));
                            Future.delayed(const Duration(milliseconds: 400))
                                .whenComplete(() => BlocProvider.of<LoginBloc>(context)
                                    .add(ReturnFromInvite()))
                                .whenComplete(() =>
                                    Future.delayed(const Duration(milliseconds: 400))
                                        .whenComplete(() =>
                                            BlocProvider.of<NavigationBloc>(context)
                                                .add(PofelDetailPageEvent(
                                                    pofelId: pofelState
                                                        .choosenPofel
                                                        .pofelId))));
                          },
                          width: double.infinity,
                        ),
                      )
                    ]);
              } else if (pofelState is PofelStateWithData &&
                  pofelState.pofelStateEnum == PofelStateEnum.ERROR_LOADING) {
                return Center(
                    child: Text("Neplatná pozvánka :/ " +
                        pofelState.errorMessage! +
                        widget.joinId));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
