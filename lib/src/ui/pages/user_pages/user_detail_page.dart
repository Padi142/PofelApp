import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/user_bloc/user_bloc.dart';
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
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 30, right: 30),
                      child: Container(
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
                              const Expanded(
                                child: Text(
                                  "Můj profil",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      BlocProvider.of<UserBloc>(context).add(
                                          UpdateUserProfilePic(newPic: image));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            userState.currentUser.isPremium ==
                                                    true
                                                ? const Color.fromARGB(
                                                    255, 247, 190, 67)
                                                : Colors.grey,
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: CircleAvatar(
                                        radius: 40,
                                        foregroundImage: NetworkImage(
                                          userState.currentUser.photo!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    userState.currentUser.name!,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          )),
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserFollowersPage(
                                          profiles:
                                              userState.currentUser.followers!,
                                        )),
                              );
                            },
                            child: Column(
                              children: [
                                const Text('Sledující: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    userState.currentUser.followers!.length
                                        .toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF3F33D4),
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              side: const BorderSide(
                                  width: 5.0, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserFollowersPage(
                                          profiles:
                                              userState.currentUser.following!,
                                        )),
                              );
                            },
                            child: Column(
                              children: [
                                const Text('Sleduji: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    userState.currentUser.following!.length
                                        .toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF3F33D4),
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              side: const BorderSide(
                                  width: 5.0, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    )),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
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
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<UserBloc>(context)
                                              .add(UpdateUserName(
                                                  newName: myController.text));
                                          Navigator.pop(context);
                                        },
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Upravit jméno",
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
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PastPofelsPage()),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Proběhlé pofely",
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
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () async {
                                  BlocProvider.of<LoginBloc>(context)
                                      .add(LogOut());
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Odhlásit se",
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
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserPremiumPage()),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Premium Page",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFEE500),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  side: const BorderSide(
                                      width: 5.0, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
