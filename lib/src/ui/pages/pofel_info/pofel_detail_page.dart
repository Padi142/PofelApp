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
                    Expanded(
                        child: Column(
                      children: [
                        Expanded(child: BlocBuilder<PofelDetailNavigationBloc,
                            PofelNavigationState>(
                          builder: (context, state) {
                            if (state is ShowPofelInfoState) {
                              return PofelInfo(
                                  context, pofelState.choosenPofel, state.uid);
                            } else if (state is PofelSignedUsersState) {
                              return PofelSignedUsers(
                                  context, pofelState.choosenPofel);
                            } else if (state is PofelItemsPageState) {
                              return PofelItemsPage(
                                  context, pofelState.choosenPofel);
                            } else if (state is LoadChatPageState) {
                              return PofelChatPage(
                                  context, pofelState.choosenPofel, state.uid);
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
