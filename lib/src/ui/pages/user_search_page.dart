import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_state.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserSearchPage extends StatefulWidget {
  UserSearchPage({Key? key}) : super(key: key);

  @override
  State<UserSearchPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<UserSearchPage> {
  final myController = TextEditingController();
  SocialBloc socialBloc = SocialBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => socialBloc,
      child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: (Text("Vyhledat uživatele: ",
                    style: TextStyle(color: Colors.black87, fontSize: 17))),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  focusNode: FocusNode(canRequestFocus: false),
                  onChanged: (text) {
                    socialBloc.add(SearchUsers(query: text));
                  },
                  decoration: InputDecoration(
                    hintText: 'Nick',
                    counterStyle: const TextStyle(color: Colors.white),
                    suffixIcon: const Icon(
                      Icons.search,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: const TextStyle(fontSize: 12),
                    contentPadding: const EdgeInsets.only(left: 30),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: BlocBuilder<SocialBloc, SocialState>(
                  builder: (context, state) {
                    if (state is SearchProfiles) {
                      return ListView.builder(
                          itemCount: state.profiles.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: GestureDetector(
                                onTap: () {
                                  alert(context, socialBloc,
                                          state.profiles[index])
                                      .show();
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF73BCFC),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: InkWell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Text(
                                                    state.profiles[index].name,
                                                    style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: CircleAvatar(
                                                radius: 30,
                                                foregroundImage: NetworkImage(
                                                  state.profiles[index].photo,
                                                  scale: 0.4,
                                                ),
                                              ),
                                            ),
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
                  },
                )),
          ]),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}

Alert alert(BuildContext context, SocialBloc socialBloc, ProfileModel profile) {
  return Alert(
    context: context,
    type: AlertType.none,
    title: "Profil",
    content: Column(
      children: [
        Image.network(
          profile.photo,
          height: MediaQuery.of(context).size.height * 0.5,
        ),
        Text(profile.name,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: () {
            socialBloc.add(Follow(userId: profile.uid));
            Navigator.pop(context);
          },
          child: const Text("Follow"),
          style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        )
      ],
    ),
    buttons: [
      DialogButton(
        child: const Text(
          "Zavřít",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  );
}
