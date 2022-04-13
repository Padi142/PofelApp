import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_state.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';

class InvitePeoplePage extends StatefulWidget {
  InvitePeoplePage({Key? key, required this.uid, required this.pofel})
      : super(key: key);
  final String uid;
  final PofelModel pofel;

  @override
  State<InvitePeoplePage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<InvitePeoplePage> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SocialBloc socialBloc = SocialBloc();
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => socialBloc,
          child: BlocListener<SocialBloc, SocialState>(
            listener: (context, state) {
              if (state is MyFollowingState) {
                switch (state.inviteEnum) {
                  case InviteEnum.INVITED:
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBarAlert(context, 'Úspěšně pozváno'));
                    break;
                  case InviteEnum.FAILED:
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBarError(context, "Uživatel tě nesleduje zpátky"));
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Zpět")),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: (Text("Pozvat uživatele: ",
                          style:
                              TextStyle(color: Colors.black87, fontSize: 17))),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: BlocBuilder<SocialBloc, SocialState>(
                        builder: (context, state) {
                          if (state is MyFollowingState) {
                            return ListView.builder(
                                itemCount: state.profiles.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFF73BCFC),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: InkWell(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    foregroundImage:
                                                        NetworkImage(
                                                      state.profiles[index]
                                                          .photo,
                                                      scale: 0.4,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: AutoSizeText(
                                                        state.profiles[index]
                                                            .name,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black87,
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
                                                      const EdgeInsets.all(12),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      socialBloc.add(InviteUser(
                                                          uid: state
                                                              .profiles[index]
                                                              .uid,
                                                          pofelId: widget
                                                              .pofel.joinCode,
                                                          pofelName: widget
                                                              .pofel.name));
                                                    },
                                                    child: const Text("Pozvat"),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            socialBloc.add(LoadMyFollowing(uid: widget.uid));
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () async {
                          await FirebaseAnalytics.instance
                              .logEvent(name: 'pofel_link_shared');

                          String link = "https://pofel.me/?invite=" +
                              widget.pofel.joinCode;
                          await FlutterShare.share(
                            title: widget.pofel.name,
                            chooserTitle: widget.pofel.name,
                            text: 'Právě jsi byl pozván na epesní pofel: ' +
                                widget.pofel.name,
                            linkUrl: link,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Sdílet pozvánku:',
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
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
