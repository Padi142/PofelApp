import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/user_bloc/user_bloc.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/pages/user_pages/past_pofels_list_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/user_followers_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/user_premium_page.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final TextEditingController myController = TextEditingController();
  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc()..add(const LoadUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is! UserLoadedState) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userState.currentUser;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
            child: Column(
              children: [
                PofelPanel(
                  child: Column(
                    children: [
                      const PofelSectionTitle('Můj profil'),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final userBloc = _userBloc;
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (!mounted || image == null) {
                            return;
                          }
                          userBloc.add(UpdateUserProfilePic(newPic: image));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: user.isPremium == true
                                  ? PofelPalette.premium
                                  : Colors.white,
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 64,
                            foregroundImage: NetworkImage(user.photo!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name!,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Sledující',
                        value: user.followers!.length.toString(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFollowersPage(
                                profiles: user.followers!,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        title: 'Sleduji',
                        value: user.following!.length.toString(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFollowersPage(
                                profiles: user.following!,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                PofelOutlineButton(
                  label: 'Upravit jméno',
                  onPressed: _showRenameDialog,
                ),
                const SizedBox(height: 16),
                PofelOutlineButton(
                  label: 'Proběhlé pofely',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PastPofelsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                PofelOutlineButton(
                  label: 'Odhlásit se',
                  onPressed: () {
                    context.read<LoginBloc>().add(LogOut());
                  },
                ),
                const SizedBox(height: 18),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPremiumPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(62),
                    side: const BorderSide(color: Colors.black, width: 3.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: PofelPalette.premium,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Premium Page',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRenameDialog() {
    myController.clear();
    showPofelModalSheet<void>(
      context: context,
      builder: (sheetContext) => PofelModalSheet(
        icon: Icons.edit_rounded,
        title: 'Upravit jméno',
        subtitle: 'Tohle jméno uvidí ostatní napříč aplikací.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: myController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              decoration: pofelModalInputDecoration(
                labelText: 'Nové jméno',
                hintText: 'Jak ti máme říkat?',
                prefixIcon: Icons.person_rounded,
              ),
              onSubmitted: (_) => _submitRename(sheetContext),
            ),
            const SizedBox(height: 20),
            PofelModalActions(
              secondaryLabel: 'Zrušit',
              onSecondary: () => Navigator.pop(sheetContext),
              primaryLabel: 'Uložit jméno',
              primaryIcon: Icons.check_rounded,
              onPrimary: () => _submitRename(sheetContext),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRename(BuildContext sheetContext) {
    final name = myController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarError(context, 'Zadej nové jméno.'),
      );
      return;
    }
    _userBloc.add(UpdateUserName(newName: name));
    Navigator.pop(sheetContext);
  }

  @override
  void dispose() {
    myController.dispose();
    _userBloc.close();
    super.dispose();
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.onPressed,
  });

  final String title;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black, width: 3.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        minimumSize: const Size.fromHeight(140),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: PofelPalette.accentBlue,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
