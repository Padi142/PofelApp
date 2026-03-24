import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/core/providers/notification_provider.dart';
import 'package:pofel_app/src/core/providers/user_provider.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/simple_date_time_picker.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/components/toast_premium_alert.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_set_location_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/bloc/pofel_bloc/pofel_event.dart';

Widget buildPofelSettingsPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();
  final notificationProvider = NotificationProvider();
  final userProvider = UserProvider();
  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _SettingsSection(
                title: 'Základní nastavení',
                subtitle: 'Jméno, popis, termín, playlist a lokace',
                children: [
                  _SettingsActionCard(
                    title: 'Upravit jméno',
                    icon: Icons.drive_file_rename_outline_rounded,
                    color: PofelPalette.primary,
                    onTap: () {
                      _showRenamePofelSheet(context, pofel, myController);
                    },
                  ),
                  _SettingsActionCard(
                    title: 'Upravit popis',
                    icon: Icons.notes_rounded,
                    color: const Color(0xFF2F6FD6),
                    onTap: () {
                      _showDescriptionSheet(context, pofel, myController);
                    },
                  ),
                  _SettingsActionCard(
                    title: 'Upravit datum',
                    icon: Icons.event_available_rounded,
                    color: const Color(0xFFD96E3C),
                    statusColor: const Color(0xFFD96E3C),
                    onTap: () {
                      _showDateSheet(context, pofel);
                    },
                  ),
                  _SettingsActionCard(
                    title: 'Upravit playlist',
                    description: 'Přidej Spotify nebo Apple Music odkaz',
                    icon: Icons.music_note_rounded,
                    color: const Color(0xFF29956A),
                    statusLabel: pofel.spotifyLink.isEmpty ? 'Chybí' : 'Připraveno',
                    statusColor: pofel.spotifyLink.isEmpty ? const Color(0xFFC36A1B) : const Color(0xFF29956A),
                    onTap: () {
                      _showSpotifySheet(context, pofel, myController);
                    },
                  ),
                  _SettingsActionCard(
                    title: 'Upravit lokaci pofelu',
                    description: 'Nastav přesné místo. ',
                    icon: Icons.place_rounded,
                    color: const Color(0xFF3857D1),
                    statusLabel: pofel.pofelLocation.latitude == 0 ? 'Chybí' : 'Nastavena',
                    statusColor: pofel.pofelLocation.latitude == 0 ? const Color(0xFFC36A1B) : const Color(0xFF29956A),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetLocationPage(pofel: pofel),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SettingsSection(
                title: 'Lidi a komunikace',
                subtitle: 'Správa rolí, notifikací a oznámení pro všechny účastníky.',
                children: [
                  _SettingsActionCard(
                    title: 'Poslat oznámení účastníkům',
                    description: 'Pošli krátkou důležitou zprávu všem lidem na pofelu.',
                    icon: Icons.campaign_rounded,
                    color: const Color(0xFF7B1BC5),
                    onTap: () {
                      _showAnnouncementSheet(
                        context,
                        pofel,
                        myController,
                        userProvider,
                        notificationProvider,
                      );
                    },
                  ),
                  _SettingsActionCard(
                    title: 'Zapnout nebo vypnout chat notifikace',
                    description: 'Změň si, jestli chceš dostávat upozornění z pofel chatu.',
                    icon: Icons.notifications_active_rounded,
                    color: const Color(0xFFFFA62B),
                    onTap: () => _toggleChatNotifications(context, pofel),
                  ),
                  _SettingsActionCard(
                    title: 'Předat admina',
                    description: 'Změnit vlastníka pofelu',
                    icon: Icons.workspace_premium_rounded,
                    color: const Color(0xFF3857D1),
                    onTap: () {
                      _showTransferAdminSheet(context, pofel);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SettingsSection(
                title: 'Funkce pofelu',
                subtitle: 'Další epické veci',
                children: [
                  _SettingsActionCard(
                    title: 'Substance itemy',
                    description: 'Přepínej, jestli se mají v itemech zobrazovat i substance.',
                    icon: Icons.auto_awesome_rounded,
                    color: const Color(0xFFDB4F8A),
                    statusLabel: pofel.showDrugItems ? 'Zapnuto' : 'Vypnuto',
                    statusColor: pofel.showDrugItems ? const Color(0xFF29956A) : const Color(0xFF7E2642),
                    onTap: () => _toggleSubstanceItems(context, pofel),
                  ),
                  _SettingsActionCard(
                    title: 'Upgradovat pofel',
                    description: 'Odemkni premium možnosti pro celý pofel. Potřebuješ pofel premium.',
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFE0B01D),
                    statusLabel: pofel.isPremium ? 'Premium' : 'Basic',
                    statusColor: pofel.isPremium ? const Color(0xFFE0B01D) : PofelPalette.primaryDark,
                    onTap: () => _upgradePofel(context, pofel),
                  ),
                  _SettingsActionCard(
                    title: pofel.isPublic ? 'Nastavit pofel jako private' : 'Nastavit pofel jako veřejný',
                    description: 'Veřejný pofel se může ukázat dalším lidem v appce.',
                    icon: pofel.isPublic ? Icons.lock_rounded : Icons.public_rounded,
                    color: const Color(0xFF1AA483),
                    statusLabel: pofel.isPublic ? 'Veřejný' : 'Private',
                    statusColor: pofel.isPublic ? const Color(0xFF1AA483) : const Color(0xFF7E2642),
                    onTap: () => _togglePublicState(context, pofel),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SettingsSection(
                title: 'Danger zone',
                subtitle: 'Smazání pofelu je nevratné a smaže všechno kolem něj.',
                children: [
                  _SettingsActionCard(
                    title: 'Smazat pofel',
                    icon: Icons.delete_forever_rounded,
                    color: const Color(0xFFC63F5C),
                    destructive: true,
                    onTap: () => _confirmDeletePofel(context, pofel),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(height: 14),
        // PofelOutlineButton(
        //   label: 'Zpět',
        //   onPressed: () {
        //     context.read<PofelDetailNavigationBloc>().add(
        //           const PofelInfoEvent(),
        //         );
        //   },
        //   color: const Color(0xFFE59AA8),
        //   textColor: const Color(0xFF7E2642),
        // ),
      ],
    ),
  );
}

Future<void> _toggleSubstanceItems(BuildContext context, PofelModel pofel) async {
  BlocProvider.of<PofelBloc>(context).add(
    UpdatePofel(
      updatePofelEnum: UpdatePofelEnum.UPDATE_SHOW_DRUGS,
      pofelId: pofel.pofelId,
      showDrugs: pofel.showDrugItems,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBarAlert(
      context,
      pofel.showDrugItems ? 'Substance itemy vypnuty' : 'Substance itemy zapnuty',
    ),
  );
}

Future<void> _toggleChatNotifications(
  BuildContext context,
  PofelModel pofel,
) async {
  final user = await _resolveCurrentPofelUser(pofel);
  if (!context.mounted) {
    return;
  }
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarError(context, 'Nepodařilo se najít tvoje nastavení notifikací.'),
    );
    return;
  }

  BlocProvider.of<PofelBloc>(context).add(
    ChatNotification(pofelId: pofel.pofelId, user: user),
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBarAlert(
      context,
      user.chatNotification ? 'Chat notifikace vypnuty' : 'Chat notifikace zapnuty',
    ),
  );
}

Future<void> _upgradePofel(BuildContext context, PofelModel pofel) async {
  final user = await _resolveCurrentPofelUser(pofel);
  if (!context.mounted) {
    return;
  }
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarError(context, 'Nepodařilo se dohledat tvůj profil v pofelu.'),
    );
    return;
  }

  if (user.isPremium) {
    BlocProvider.of<PofelBloc>(context).add(
      UpdatePofel(
        pofelId: pofel.pofelId,
        updatePofelEnum: UpdatePofelEnum.UPGRADE_POFEL,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarPremiumAlert(context, 'Pofel upgradován!'),
    );
    return;
  }

  Alert(
    context: context,
    type: AlertType.error,
    title: "Premiová feature :/",
    desc: "Tato funkce je dostupná pouze pro prémiové uživatele.",
    buttons: [
      DialogButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        width: 120,
        child: const Text(
          "Zavřít",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  ).show();
}

Future<void> _togglePublicState(BuildContext context, PofelModel pofel) async {
  if (pofel.isPremium) {
    if (pofel.pofelLocation.latitude != 0) {
      BlocProvider.of<PofelBloc>(context).add(
        UpdatePofel(
          pofelId: pofel.pofelId,
          updatePofelEnum: UpdatePofelEnum.UPDATE_IS_PUBLIC,
          isPublic: pofel.isPublic,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarAlert(
          context,
          pofel.isPublic ? 'Pofel je teď private' : 'Pofel je teď veřejný',
        ),
      );
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Není nastavená lokace",
        desc: "Nejprve nastav lokaci pofelu. Až poté ho můžeš dát jako veřejný!",
        buttons: [
          DialogButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            width: 120,
            child: const Text(
              "Zavřít",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }
  } else {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Premiová feature :/",
      desc: "Tato funkce je dostupná pouze pro prémiové pofely. Upgraduj pofel nebo mi napiš na ig a nějak se domluvíme!",
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "Zavřít",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }
}

void _confirmDeletePofel(BuildContext context, PofelModel pofel) {
  Alert(
    context: context,
    type: AlertType.none,
    title: "Fakt jo?",
    desc: "Opravdu chceš smazat pofel?",
    content: Column(
      children: const [],
    ),
    buttons: [
      DialogButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarAlert(context, 'Pofel smazán'),
          );
          Navigator.pop(context);
          BlocProvider.of<PofelBloc>(context).add(
            DeletePofel(pofelId: pofel.pofelId),
          );
        },
        width: 140,
        child: const Text(
          "Smazat",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  ).show();
}

Future<PofelUserModel?> _resolveCurrentPofelUser(PofelModel pofel) async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString("uid");
  if (uid == null) {
    return null;
  }

  for (final user in pofel.signedUsers) {
    if (user.uid == uid) {
      return user;
    }
  }

  return null;
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: PofelPalette.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: PofelPalette.text.withValues(alpha: 0.64),
          ),
        ),
        const SizedBox(height: 12),
        ..._withSpacing(children, const SizedBox(height: 12)),
      ],
    );
  }
}

class _SettingsActionCard extends StatelessWidget {
  const _SettingsActionCard({
    required this.title,
    this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.statusLabel,
    this.statusColor,
    this.destructive = false,
  });

  final String title;
  final String? description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? statusLabel;
  final Color? statusColor;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final hasDescription = description != null && description!.trim().isNotEmpty;
    final hasStatus = statusLabel != null && statusColor != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: PofelSurfaceCard(
        child: Row(
          crossAxisAlignment: hasDescription || hasStatus ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: destructive ? const Color(0xFF9C2342) : PofelPalette.text,
                    ),
                  ),
                  if (hasDescription) ...[
                    const SizedBox(height: 5),
                    Text(
                      description!,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PofelPalette.text.withValues(alpha: 0.64),
                      ),
                    ),
                  ],
                  if (hasStatus) ...[
                    SizedBox(height: hasDescription ? 10 : 8),
                    _SettingsStatusPill(
                      label: statusLabel!,
                      color: statusColor!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.chevron_right_rounded,
              color: destructive ? const Color(0xFF9C2342) : PofelPalette.text.withValues(alpha: 0.42),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsStatusPill extends StatelessWidget {
  const _SettingsStatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

List<Widget> _withSpacing(List<Widget> children, Widget spacer) {
  if (children.isEmpty) {
    return const [];
  }

  final items = <Widget>[];
  for (var index = 0; index < children.length; index++) {
    if (index > 0) {
      items.add(spacer);
    }
    items.add(children[index]);
  }
  return items;
}

void _showRenamePofelSheet(
  BuildContext context,
  PofelModel pofel,
  TextEditingController controller,
) {
  controller
    ..clear()
    ..text = pofel.name;

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.drive_file_rename_outline_rounded,
      title: 'Přejmenovat pofel',
      subtitle: 'Krátký, zapamatovatelný název se pak bude zobrazovat všem.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: pofelModalInputDecoration(
              labelText: 'Nové jméno',
              hintText: 'Jak se bude pofel jmenovat?',
              prefixIcon: Icons.badge_rounded,
            ),
            onSubmitted: (_) {
              final value = controller.text.trim();
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarError(context, 'Zadej nové jméno pofelu.'),
                );
                return;
              }
              BlocProvider.of<PofelBloc>(context).add(
                UpdatePofel(
                  updatePofelEnum: UpdatePofelEnum.UPDATE_NAME,
                  pofelId: pofel.pofelId,
                  newName: value,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarAlert(context, 'Úspěšně přejmenováno'),
              );
              Navigator.pop(sheetContext);
            },
          ),
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zrušit',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel: 'Uložit jméno',
            primaryIcon: Icons.check_rounded,
            onPrimary: () {
              final value = controller.text.trim();
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarError(context, 'Zadej nové jméno pofelu.'),
                );
                return;
              }
              BlocProvider.of<PofelBloc>(context).add(
                UpdatePofel(
                  updatePofelEnum: UpdatePofelEnum.UPDATE_NAME,
                  pofelId: pofel.pofelId,
                  newName: value,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarAlert(context, 'Úspěšně přejmenováno'),
              );
              Navigator.pop(sheetContext);
            },
          ),
        ],
      ),
    ),
  );
}

void _showDescriptionSheet(
  BuildContext context,
  PofelModel pofel,
  TextEditingController controller,
) {
  controller
    ..clear()
    ..text = pofel.description;

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.notes_rounded,
      title: 'Upravit popis',
      subtitle: 'Napiš ostatním, co je čeká, co vzít s sebou nebo jaký je vibe akce.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            minLines: 4,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: pofelModalInputDecoration(
              labelText: 'Popis pofelu',
              hintText: 'Co mají ostatní vědět?',
              prefixIcon: Icons.edit_note_rounded,
            ),
          ),
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zrušit',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel: 'Uložit popis',
            primaryIcon: Icons.check_rounded,
            onPrimary: () {
              final value = controller.text.trim();
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarError(context, 'Popis nemůže být prázdný.'),
                );
                return;
              }
              BlocProvider.of<PofelBloc>(context).add(
                UpdatePofel(
                  updatePofelEnum: UpdatePofelEnum.UPDATE_DESC,
                  pofelId: pofel.pofelId,
                  newDesc: value,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarAlert(context, 'Úspěšně upraveno'),
              );
              Navigator.pop(sheetContext);
            },
          ),
        ],
      ),
    ),
  );
}

void _showDateSheet(BuildContext context, PofelModel pofel) {
  DateTime? pickedDate = pofel.dateFrom;

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.event_available_rounded,
      title: 'Upravit datum',
      subtitle: 'Posuň termín a všichni budou mít hned jasno, kdy se jde ven.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimpleDateTimePicker(
            initialDate: pofel.dateFrom,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            labelText: 'Datum a čas',
            onChanged: (value) {
              pickedDate = value;
            },
          ),
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zrušit',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel: 'Uložit termín',
            primaryIcon: Icons.schedule_send_rounded,
            onPrimary: () {
              if (pickedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarError(context, 'Vyber nové datum a čas.'),
                );
                return;
              }
              BlocProvider.of<PofelBloc>(context).add(
                UpdatePofel(
                  pofelId: pofel.pofelId,
                  updatePofelEnum: UpdatePofelEnum.UPDATE_DATE,
                  newDate: pickedDate,
                ),
              );
              Navigator.pop(sheetContext);
            },
          ),
        ],
      ),
    ),
  );
}

void _showSpotifySheet(
  BuildContext context,
  PofelModel pofel,
  TextEditingController controller,
) {
  controller
    ..clear()
    ..text = pofel.spotifyLink;

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.music_note_rounded,
      title: 'Playlist pofelu',
      subtitle: 'Přidej odkaz na Spotify nebo Apple Music a nalaď ostatní ještě před startem.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            decoration: pofelModalInputDecoration(
              labelText: 'Odkaz na playlist',
              hintText: 'https://open.spotify.com/...',
              prefixIcon: Icons.link_rounded,
              helperText: 'Podporujeme Spotify i Apple Music odkazy.',
            ),
          ),
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zrušit',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel: 'Uložit odkaz',
            primaryIcon: Icons.library_music_rounded,
            onPrimary: () {
              final value = controller.text.trim();
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarError(context, 'Vlož odkaz na playlist.'),
                );
                return;
              }
              if (!value.contains("spotify") && !value.contains("apple")) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarError(context, 'Neplatný Spotify nebo Apple Music odkaz.'),
                );
                return;
              }
              BlocProvider.of<PofelBloc>(context).add(
                UpdatePofel(
                  updatePofelEnum: UpdatePofelEnum.UPDATE_SPOTIFY,
                  pofelId: pofel.pofelId,
                  newSpotifyLink: value,
                ),
              );
              Navigator.pop(sheetContext);
            },
          ),
        ],
      ),
    ),
  );
}

void _showTransferAdminSheet(BuildContext context, PofelModel pofel) {
  final form = fb.group(<String, Object>{
    'clovek': FormControl<String>(validators: [Validators.required]),
  });

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.workspace_premium_rounded,
      title: 'Předat admina',
      subtitle: 'Vyber člověka, který převezme správu pofelu.',
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReactiveDropdownField<String>(
              formControlName: 'clovek',
              validationMessages: {
                ValidationMessage.required: (_) => 'Vyber nového admina.',
              },
              decoration: pofelModalInputDecoration(
                labelText: 'Nový admin',
                hintText: 'Koho povýšíme?',
                prefixIcon: Icons.admin_panel_settings_rounded,
              ),
              items: getDropdownItems(pofel.signedUsers),
            ),
            const SizedBox(height: 20),
            PofelModalActions(
              secondaryLabel: 'Zrušit',
              onSecondary: () => Navigator.pop(sheetContext),
              primaryLabel: 'Předat roli',
              primaryIcon: Icons.arrow_circle_right_rounded,
              onPrimary: () {
                if (!form.valid) {
                  form.markAllAsTouched();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarError(context, 'Vyber, komu chceš admina předat.'),
                  );
                  return;
                }
                final assignedUid = form.control('clovek').value as String?;
                if (assignedUid == null || assignedUid.isEmpty) {
                  return;
                }
                BlocProvider.of<PofelBloc>(context).add(
                  ChangeAdmin(
                    pofelId: pofel.pofelId,
                    uid: assignedUid,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarAlert(context, 'Admin předán'),
                );
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void _showAnnouncementSheet(
  BuildContext context,
  PofelModel pofel,
  TextEditingController controller,
  UserProvider userProvider,
  NotificationProvider notificationProvider,
) {
  controller.clear();

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.campaign_rounded,
      title: 'Poslat oznámení',
      subtitle: 'Krátká zpráva se pošle všem účastníkům pofelu jako upozornění.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: pofelModalInputDecoration(
              labelText: 'Zpráva',
              hintText: 'Např. Přineste si hotovost a dorazte včas.',
              prefixIcon: Icons.forum_rounded,
            ),
          ),
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zrušit',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel: 'Poslat všem',
            primaryIcon: Icons.send_rounded,
            onPrimary: () async {
              final message = controller.text.trim();
              if (message.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBarError(context, 'Napiš zprávu pro účastníky.'),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarAlert(context, 'Notifikace poslána'),
              );
              Navigator.pop(sheetContext);

              final prefs = await SharedPreferences.getInstance();
              final uid = prefs.getString("uid");
              if (uid != null) {
                final user = await userProvider.fetchUserData(uid);
                await notificationProvider.notifyPofelUsers(
                  sentByUid: uid,
                  sentByName: user.name ?? 'Pofel',
                  sentByProfilePic: user.photo ?? 'https://ui-avatars.com/api/?background=8F3BB7&color=ffffff&name=Pofel',
                  pofelId: pofel.pofelId,
                  message: message,
                  type: NotificationType.announcement,
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

List<DropdownMenuItem<String>> getDropdownItems(List<PofelUserModel> users) {
  List<DropdownMenuItem<String>> items = [];
  for (PofelUserModel user in users) {
    items.add(
      DropdownMenuItem(
        value: user.uid,
        child: Text(user.name),
      ),
    );
  }
  return items;
}
