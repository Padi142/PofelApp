import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/user_bloc/user_bloc.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:pofel_app/src/ui/components/follower_container.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_info_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_settings_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_signed_users.dart';
import 'package:pofel_app/src/ui/pages/user_pages/past_pofels_list_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/user_followers_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/user_premium_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<UserDetailPage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = UserBloc();
    _userBloc.add(const LoadUser());

    return BlocProvider(
      create: (context) => _userBloc,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is UserLoadedState) {
            return Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                        color: userState.currentUser.isPremium == true
                            ? const Color.fromARGB(255, 247, 190, 67)
                            : Colors.grey,
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                    userState.currentUser.photo!,
                                    height: 100,
                                    width: 100),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Jméno: "),
                                  Text(userState.currentUser.name!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Text("Sledující:"),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            margin: const EdgeInsets.all(3),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserFollowersPage(
                                                            profiles: userState
                                                                .currentUser
                                                                .followers!,
                                                          )),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Center(
                                                  child: Text(
                                                      userState.currentUser
                                                          .followers!.length
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF73BCFC),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text("Sleduji:"),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            margin: const EdgeInsets.all(3),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserFollowersPage(
                                                            profiles: userState
                                                                .currentUser
                                                                .following!,
                                                          )),
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Center(
                                                  child: Text(
                                                      userState.currentUser
                                                          .following!.length
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF73BCFC),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ))),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Alert(
                              context: context,
                              type: AlertType.none,
                              desc: "Zadejte nové jméno",
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
                                    "Přejmenovat",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<UserBloc>(context).add(
                                        UpdateUserName(
                                            newName: myController.text));
                                    Navigator.pop(context);
                                  },
                                  width: 120,
                                )
                              ],
                            ).show();
                          },
                          child: const Text("Upravit jméno"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              BlocProvider.of<UserBloc>(context)
                                  .add(UpdateUserProfilePic(newPic: image));
                            }
                          },
                          child: const AutoSizeText("Upravit profilovku"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PastPofelsPage()),
                            );
                          },
                          child: const Text("Proběhlé pofely"),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<LoginBloc>(context).add(LogOut());
                  },
                  child: const Text("Odhlásit se"),
                ),
                Expanded(child: Container()),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.maxFinite,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 247, 190, 67),
                            Color.fromARGB(255, 245, 245, 39)
                          ],
                        )),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserPremiumPage()),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Premium page",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
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
