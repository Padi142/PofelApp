import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/user_bloc/user_bloc.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<UserDetailPage> {
  final myController = TextEditingController();
  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc()..add(const LoadUser());
  }

  @override
  Widget build(BuildContext context) {
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
                        color: Colors.grey,
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
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            )
                          ],
                        ))),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          myController.clear();
                          showPofelModalSheet<void>(
                            context: context,
                            builder: (sheetContext) => PofelModalSheet(
                              icon: Icons.edit_rounded,
                              title: 'Upravit jméno',
                              subtitle:
                                  'Rychlá úprava profilu v novém Pofel stylu.',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    controller: myController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: pofelModalInputDecoration(
                                      labelText: 'Nové jméno',
                                      hintText: 'Tvoje přezdívka',
                                      prefixIcon: Icons.person_rounded,
                                    ),
                                    onSubmitted: (_) {
                                      final name = myController.text.trim();
                                      if (name.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBarError(
                                            context,
                                            'Zadej nové jméno.',
                                          ),
                                        );
                                        return;
                                      }
                                      _userBloc.add(
                                        UpdateUserName(newName: name),
                                      );
                                      Navigator.pop(sheetContext);
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  PofelModalActions(
                                    secondaryLabel: 'Zrušit',
                                    onSecondary: () =>
                                        Navigator.pop(sheetContext),
                                    primaryLabel: 'Přejmenovat',
                                    primaryIcon: Icons.check_rounded,
                                    onPrimary: () {
                                      final name = myController.text.trim();
                                      if (name.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBarError(
                                            context,
                                            'Zadej nové jméno.',
                                          ),
                                        );
                                        return;
                                      }
                                      _userBloc.add(
                                        UpdateUserName(newName: name),
                                      );
                                      Navigator.pop(sheetContext);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Text("Upravit jméno"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            _userBloc.add(UpdateUserProfilePic(newPic: image));
                          }
                        },
                        child: const AutoSizeText("Upravit profilovku"),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    BlocProvider.of<LoginBloc>(context).add(LogOut());
                  },
                  child: const Text("Odhlásit se"),
                ),
                Expanded(flex: 1, child: Container())
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

  @override
  void dispose() {
    myController.dispose();
    _userBloc.close();
    super.dispose();
  }
}
