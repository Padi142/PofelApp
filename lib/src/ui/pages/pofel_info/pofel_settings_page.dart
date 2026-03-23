import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/core/providers/notification_provider.dart';
import 'package:pofel_app/src/core/providers/user_provider.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/simple_date_time_picker.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/components/toast_premium_alert.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/pofel_set_location_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/bloc/pofel_bloc/pofel_event.dart';

Widget PofelSettignsPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();
  final notificationProvider = NotificationProvider();
  final userProvider = UserProvider();
  return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _showRenamePofelSheet(context, pofel, myController);
                },
                child: const Text("Upravit jméno"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent),
                onPressed: () {
                  _showDescriptionSheet(context, pofel, myController);
                },
                child: const Text("Upravit popis"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent),
                onPressed: () {
                  _showDateSheet(context, pofel);
                },
                child: const Text("Upravit datum"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent),
                onPressed: () {
                  _showSpotifySheet(context, pofel, myController);
                },
                child: const Text("Upravit spotify playlist",
                    style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SetLocationPage(pofel: pofel)),
                  );
                },
                child: const Text("📍 Upravit lokaci pofelu"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent),
                onPressed: () {
                  BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                      updatePofelEnum: UpdatePofelEnum.UPDATE_SHOW_DRUGS,
                      pofelId: pofel.pofelId,
                      showDrugs: pofel.showDrugItems));
                },
                child: const Text("Zapnout/vypnout substance itemy"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String? uid = prefs.getString("uid");

                  PofelUserModel user =
                      pofel.signedUsers.firstWhere((user) => user.uid == uid);
                  BlocProvider.of<PofelBloc>(context).add(
                      ChatNotification(pofelId: pofel.pofelId, user: user));
                },
                child: const Text("Zapnout/vypnout chat notifikace",
                    style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent),
                onPressed: () {
                  _showTransferAdminSheet(context, pofel);
                },
                child: const Text("Předat admina"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String? uid = prefs.getString("uid");

                  PofelUserModel user =
                      pofel.signedUsers.firstWhere((user) => user.uid == uid);
                  if (user.isPremium) {
                    BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                        pofelId: pofel.pofelId,
                        updatePofelEnum: UpdatePofelEnum.UPGRADE_POFEL));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBarPremiumAlert(context, 'Pofel upgradován!'));
                  } else {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Premiová feature :/",
                      desc:
                          "Tato funkce je dostupná pouze pro prémiové uživatele.",
                      buttons: [
                        DialogButton(
                          child: const Text(
                            "Zavřít",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                },
                child: const Text("✨ Upgradovat pofel ✨",
                    style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent),
                onPressed: () async {
                  if (pofel.isPremium) {
                    //Check jestli je nastavená lokace
                    if (pofel.pofelLocation.latitude != 0) {
                      BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                          pofelId: pofel.pofelId,
                          updatePofelEnum: UpdatePofelEnum.UPDATE_IS_PUBLIC,
                          isPublic: pofel.isPublic));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBarAlert(
                          context, 'Pofel nastaven jako veřejný!'));
                    } else {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Není nastavená lokace",
                        desc:
                            "Nejprve nastav lokaci pofelu. Až poté ho můžeš dát jako veřejný!",
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Zavřít",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    }
                  } else {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Premiová feature :/",
                      desc:
                          "Tato funkce je dostupná pouze pro prémiové pofely. Upgraduj pofel nebo mi napiš na ig a nějak se domluvíme!",
                      buttons: [
                        DialogButton(
                          child: const Text(
                            "Zavřít",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                },
                child: pofel.isPublic
                    ? const Text("🚫Nastavit pofel jako private",
                        style: TextStyle(color: Colors.black))
                    : const Text("🌄Nastavit pofel jako veřejný",
                        style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent),
                onPressed: () {
                  _showAnnouncementSheet(
                    context,
                    pofel,
                    myController,
                    userProvider,
                    notificationProvider,
                  );
                },
                child: const Text("📢 Pošli oznámění účastníkům pofelu"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Alert(
                    context: context,
                    type: AlertType.none,
                    title: "Faktr??",
                    desc: "Opravdu chceš smazat pofel?",
                    content: Column(
                      children: const [],
                    ),
                    buttons: [
                      DialogButton(
                        child: const Text(
                          "🗑️🗑️",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBarAlert(context, 'Pofel smazar💀'));

                          Navigator.pop(context);
                          BlocProvider.of<PofelBloc>(context)
                              .add(DeletePofel(pofelId: pofel.pofelId));
                        },
                        width: 120,
                      )
                    ],
                  ).show();
                },
                child: const Text("Smazat pofel 💀✋"),
              ),
            ],
          ),
        ),
      ));
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
      subtitle:
          'Napiš ostatním, co je čeká, co vzít s sebou nebo jaký je vibe akce.',
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
      subtitle:
          'Přidej odkaz na Spotify nebo Apple Music a nalaď ostatní ještě před startem.',
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
                  SnackBarError(
                      context, 'Neplatný Spotify nebo Apple Music odkaz.'),
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
      subtitle:
          'Krátká zpráva se pošle všem účastníkům pofelu jako upozornění.',
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
                  sentByProfilePic: user.photo ??
                      'https://ui-avatars.com/api/?background=8F3BB7&color=ffffff&name=Pofel',
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
        child: Text(user.name),
        value: user.uid,
      ),
    );
  }
  return items;
}
