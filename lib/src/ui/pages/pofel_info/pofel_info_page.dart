import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pofel_app/src/core/appwrite/app_services.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:pofel_app/src/core/providers/pofel_items_provider.dart';
import 'package:pofel_app/src/core/providers/pofel_todo_provider.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/invite_people_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';

Widget buildPofelInfo(
  BuildContext context,
  PofelModel pofel,
  String currentUserUid,
) {
  final telemetry = AppTelemetry();
  final itemsProvider = ItemsProvider();
  final todoProvider = TodoProvider();

  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PofelPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PofelInfoRow(
                label: 'Join code:',
                value: pofel.joinCode,
                onTap: () => _copyJoinCode(context, pofel, telemetry),
              ),
              const SizedBox(height: 12),
              PofelInfoRow(
                label: 'Datum:',
                value: DateFormat('dd.MM. – kk:mm').format(pofel.dateFrom!),
              ),
              const SizedBox(height: 12),
              PofelInfoRow(
                label: 'Účastníků:',
                value: pofel.signedUsers.length.toString(),
                onTap: () {
                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(const PofelSignedUsersEvent());
                },
              ),
              const SizedBox(height: 18),
              PofelActionPill(
                label: 'Přejít do chatu',
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () {
                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(const LoadChatPage());
                },
              ),
              const SizedBox(height: 10),
              PofelActionPill(
                label: 'Pozvat lidi',
                icon: Icons.group_add_rounded,
                onTap: () => _openInvitePeople(context, pofel, currentUserUid),
              ),
              const SizedBox(height: 10),
              PofelActionPill(
                label: 'Itemy',
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(const PofelItemsEvent());
                },
              ),
              const SizedBox(height: 10),
              PofelActionPill(
                label: 'Questy',
                icon: Icons.question_mark_rounded,
                onTap: () {
                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(const LoadTodosPage());
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Center(child: PofelSectionTitle('Uživatelé')),
        const SizedBox(height: 10),
        PofelSurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ListView.builder(
            itemCount:
                pofel.signedUsers.length > 5 ? 5 : pofel.signedUsers.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final user = pofel.signedUsers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<PofelDetailNavigationBloc>(context)
                        .add(const PofelSignedUsersEvent());
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: user.isPremium
                          ? PofelPalette.premium.withValues(alpha: 0.6)
                          : PofelPalette.softLilac.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          foregroundImage: NetworkImage(user.photo),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 12,
          runSpacing: 14,
          children: [
            PofelQuickAction(
              label: 'Galerie',
              icon: Icons.photo_library_outlined,
              onTap: () async {
                await telemetry.logEvent('galery_opened');
                if (context.mounted) {
                  BlocProvider.of<PofelDetailNavigationBloc>(context)
                      .add(const LoadImageGaleryPage());
                }
              },
            ),
            PofelQuickAction(
              label: 'Hudba',
              icon: Icons.music_note_rounded,
              onTap: () async {
                await telemetry.logEvent('spotify_opened');
                if (!context.mounted) {
                  return;
                }
                if (pofel.spotifyLink.isNotEmpty) {
                  await launchUrl(Uri.parse(pofel.spotifyLink));
                } else {
                  _showInfoAlert(
                    context,
                    "Spotify link",
                    "Spotify link ještě není nastaven. Řekni adminovi, aby přidal playlist pofelu.",
                  );
                }
              },
            ),
            PofelQuickAction(
              label: 'Mapa',
              icon: Icons.map_rounded,
              onTap: () async {
                await telemetry.logEvent('map_oppened');
                if (!context.mounted) {
                  return;
                }
                if (pofel.pofelLocation.latitude != 0) {
                  MapsLauncher.launchCoordinates(
                    pofel.pofelLocation.latitude,
                    pofel.pofelLocation.longitude,
                  );
                } else {
                  _showInfoAlert(
                    context,
                    "Lokace",
                    "Lokace ještě není nastavena. Řekni adminovi, aby ji přidal.",
                  );
                }
              },
            ),
            PofelQuickAction(
              label: 'Nastavení',
              icon: Icons.settings_rounded,
              onTap: () {
                BlocProvider.of<PofelDetailNavigationBloc>(context).add(
                  PofelSettingsEvent(adminUid: pofel.adminUid),
                );
              },
            ),
          ],
        ),
        if (pofel.description.isNotEmpty) ...[
          const SizedBox(height: 22),
          const PofelSectionTitle('Popis'),
          const SizedBox(height: 10),
          PofelSurfaceCard(
            child: Text(
              pofel.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        const SizedBox(height: 22),
        const PofelSectionTitle('Poslední itemy'),
        const SizedBox(height: 10),
        FutureBuilder<List<ItemModel>>(
          future: itemsProvider.fetchPofelItems(pofel.pofelId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data!.take(5).toList();
            if (items.isEmpty) {
              return const PofelSurfaceCard(
                child: Text(
                  'Zatím tu nejsou žádné itemy.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            }
            return Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<PofelDetailNavigationBloc>(context)
                          .add(const PofelItemsEvent());
                    },
                    child: PofelSurfaceCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              '${item.count}x ${item.name}',
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 22,
                            foregroundImage:
                                NetworkImage(item.addedByProfilePic),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 12),
        PofelOutlineButton(
          label: 'Otevřít itemy',
          onPressed: () {
            BlocProvider.of<PofelDetailNavigationBloc>(context)
                .add(const PofelItemsEvent());
          },
        ),
        const SizedBox(height: 22),
        const PofelSectionTitle('Poslední questy'),
        const SizedBox(height: 10),
        FutureBuilder<List<TodoModel>>(
          future: todoProvider.fetchTodos(pofel.pofelId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final todos =
                snapshot.data!.where((todo) => !todo.isDone).take(5).toList();
            if (todos.isEmpty) {
              return const PofelSurfaceCard(
                child: Text(
                  'Zatím tu nejsou žádné questy.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            }
            return Column(
              children: todos.map((todo) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<PofelDetailNavigationBloc>(context)
                          .add(const LoadTodosPage());
                    },
                    child: PofelSurfaceCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  todo.todoTitle,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  todo.assignedToName,
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 22,
                            foregroundImage:
                                NetworkImage(todo.assignedToProfilePic),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 12),
        PofelOutlineButton(
          label: 'Otevřít questy',
          onPressed: () {
            BlocProvider.of<PofelDetailNavigationBloc>(context)
                .add(const LoadTodosPage());
          },
        ),
      ],
    ),
  );
}

Future<void> _copyJoinCode(
  BuildContext context,
  PofelModel pofel,
  AppTelemetry telemetry,
) async {
  final link = "https://pofel.me/?invite=${pofel.joinCode}";
  await Clipboard.setData(ClipboardData(text: link));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Zkopírováno do schránky")),
    );
  }
  await telemetry.logEvent('pofel_link_coppied');
}

Future<void> _openInvitePeople(
  BuildContext context,
  PofelModel pofel,
  String currentUserUid,
) async {
  var uid = currentUserUid;
  if (uid.isEmpty) {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid") ?? '';
  }
  if (!context.mounted || uid.isEmpty) {
    return;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => InvitePeoplePage(uid: uid, pofel: pofel),
    ),
  );
}

void _showInfoAlert(
  BuildContext context,
  String title,
  String description,
) {
  Alert(
    context: context,
    type: AlertType.info,
    title: title,
    desc: description,
    content: Column(),
    buttons: [
      DialogButton(
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
        child: const Text(
          "Zavřít",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}
