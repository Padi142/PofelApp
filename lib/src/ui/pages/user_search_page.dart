import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_state.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PofelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: PofelSectionTitle('Najdi lidi'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Vyhledej profily podle jména nebo UID a otevři jejich detail.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: PofelPalette.shadow,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (text) {
                      context.read<SocialBloc>().add(SearchUsers(query: text));
                    },
                    style: const TextStyle(
                      color: PofelPalette.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Zadej jméno nebo UID',
                      hintStyle: TextStyle(
                        color: PofelPalette.text.withValues(alpha: 0.45),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: PofelPalette.primary,
                        size: 28,
                      ),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                                context
                                    .read<SocialBloc>()
                                    .add(const SearchUsers(query: ''));
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: PofelPalette.text,
                              ),
                            ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<SocialBloc, SocialState>(
            builder: (context, state) {
              if (state is! SearchProfiles) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (_searchController.text.trim().isEmpty) {
                return const _SearchHintCard(
                  icon: Icons.travel_explore_rounded,
                  title: 'Začni hledat',
                  description:
                      'Napiš jméno kamaráda a výsledky se objeví hned pod vyhledáváním.',
                );
              }

              if (state.profiles.isEmpty) {
                return const _SearchHintCard(
                  icon: Icons.person_search_rounded,
                  title: 'Nikdo nenalezen',
                  description:
                      'Zkus jiné jméno nebo UID. Vyhledávání bere prvních 10 shod.',
                );
              }

              return Column(
                children: state.profiles
                    .map(
                      (profile) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _ProfileResultCard(
                          profile: profile,
                          onTap: () => _showProfileDialog(profile),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(ProfileModel profile) {
    Alert(
      context: context,
      type: AlertType.none,
      title: 'Profil',
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: profile.isPremium
                    ? PofelPalette.premium
                    : PofelPalette.primary,
                width: 4,
              ),
            ),
            child: CircleAvatar(
              radius: 62,
              foregroundImage: NetworkImage(profile.photo),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PofelPalette.text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            profile.uid,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PofelPalette.text.withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: PofelGradientButton(
              label: 'Sledovat',
              icon: Icons.person_add_alt_1_rounded,
              onPressed: () {
                context.read<SocialBloc>().add(Follow(userId: profile.uid));
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          width: 140,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Zavřít',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _ProfileResultCard extends StatelessWidget {
  const _ProfileResultCard({
    required this.profile,
    required this.onTap,
  });

  final ProfileModel profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: PofelSurfaceCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: profile.isPremium
                      ? PofelPalette.premium
                      : PofelPalette.softLilac,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                foregroundImage: NetworkImage(profile.photo),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: PofelPalette.text,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.uid,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: PofelPalette.text.withValues(alpha: 0.55),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: PofelPalette.buttonGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHintCard extends StatelessWidget {
  const _SearchHintCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: PofelPalette.panelGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: Colors.white, size: 38),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PofelPalette.text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PofelPalette.text.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
