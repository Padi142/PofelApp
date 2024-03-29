import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:pofel_app/src/core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_chat_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_images_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_info_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_items_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_settings_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_signed_users.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_todos_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_user_settings_page.dart';

class PofelDetailPage extends StatefulWidget {
  const PofelDetailPage({Key? key, required this.pofelId}) : super(key: key);
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
      child: BlocListener<PofelBloc, PofelState>(
        listener: (context, pofelState) {
          if (pofelState is PofelStateWithData) {
            switch (pofelState.pofelStateEnum) {
              case PofelStateEnum.POFEL_UPDATED:
                BlocProvider.of<PofelBloc>(context)
                    .add(LoadPofel(pofelId: widget.pofelId));
                break;
              case PofelStateEnum.WILL_ARIVE_UPDATED:
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBarAlert(context, 'Příjezd upraven'));
                BlocProvider.of<PofelBloc>(context)
                    .add(LoadPofel(pofelId: widget.pofelId));
                break;
              case PofelStateEnum.PERSON_LEFT:
                BlocProvider.of<PofelBloc>(context)
                    .add(LoadPofel(pofelId: widget.pofelId));
                break;
              default:
                break;
            }
          }
        },
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
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                              onTap: () {
                                BlocProvider.of<PofelDetailNavigationBloc>(
                                        context)
                                    .add(const PofelInfoEvent());
                              },
                              child: AutoSizeText(pofelState.choosenPofel.name,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                BlocProvider.of<PofelDetailNavigationBloc>(
                                        context)
                                    .add(PofelSettingsEvent(
                                        adminUid:
                                            pofelState.choosenPofel.adminUid));
                              },
                              child: Column(
                                children: const [
                                  AutoSizeText("nastaveni"),
                                  Icon(Icons.settings),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            //Expanded(
                            //   child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceEvenly,
                            //       children: [
                            //     ElevatedButton(
                            //       onPressed: () {
                            //         _pofelBloc.add(const PofelInfoEvent());
                            //       },
                            //       child: const Text("Info"),
                            //     ),
                            //     ElevatedButton(
                            //       onPressed: () {
                            //         _pofelBloc
                            //             .add(const PofelSignedUsersEvent());
                            //       },
                            //       child: const Text("Users"),
                            //     ),
                            //     ElevatedButton(
                            //       onPressed: () {
                            //         _pofelBloc.add(const LoadChatPage());
                            //       },
                            //       child: const Text("Chat"),
                            //     ),
                            //     ElevatedButton(
                            //       onPressed: () {
                            //         _pofelBloc.add(const PofelItemsEvent());
                            //       },
                            //       child: const Text("Items"),
                            //     ),
                            //     ElevatedButton(
                            //       onPressed: () {
                            //         _pofelBloc.add(PofelSettingsEvent(
                            //             adminUid: pofelState
                            //                 .choosenPofel.adminUid));
                            //       },
                            //       child: const Text("Settings"),
                            //     )
                            //   ])),
                            Expanded(child: BlocBuilder<
                                PofelDetailNavigationBloc,
                                PofelNavigationState>(
                              builder: (context, state) {
                                if (state is ShowPofelInfoState) {
                                  return PofelInfo(context,
                                      pofelState.choosenPofel, state.uid);
                                } else if (state is PofelSignedUsersState) {
                                  return PofelSignedUsers(
                                      context, pofelState.choosenPofel);
                                } else if (state is PofelItemsPageState) {
                                  return PofelItemsPage(
                                      context, pofelState.choosenPofel);
                                } else if (state is LoadChatPageState) {
                                  return PofelChatPage(context,
                                      pofelState.choosenPofel, state.uid);
                                } else if (state is LoadTodosPageState) {
                                  return PofelTodosPage(
                                      context, pofelState.choosenPofel);
                                } else if (state is LoadPofelGaleryState) {
                                  return PofelImageGalery(
                                      context, pofelState.choosenPofel);
                                } else if (state is PofelSettingsPageState) {
                                  if (state.canAcces) {
                                    return PofelSettignsPage(
                                        context, pofelState.choosenPofel);
                                  } else {
                                    return UserSettingPage(
                                        context, pofelState.choosenPofel);
                                  }
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
      ),
    );
  }
}
