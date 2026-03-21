import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:pofel_app/src/core/providers/notification_provider.dart';
import 'package:pofel_app/src/ui/components/notifications/invite_notification.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../components/notifications/follow_notification.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key? key, required this.currentUid}) : super(key: key);
  final String currentUid;

  @override
  State<NotificationsPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<NotificationsPage> {
  final myController = TextEditingController();
  final NotificationProvider _notificationProvider = NotificationProvider();
  int notOption = 0;

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Upozornění",
                  style: TextStyle(color: Colors.black87, fontSize: 17)),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      notOption = 0;
                    });
                  },
                  child: const Text("Všechno")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      notOption = 1;
                    });
                  },
                  child: const Text("Pozvánky")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      notOption = 2;
                    });
                  },
                  child: const Text("Follows")),
            ],
          )),
          Expanded(
            flex: 5,
            child: FutureBuilder<List<NotificationModel>>(
              future: _notificationProvider.fetchNotifications(widget.currentUid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: const [
                      Text("Notifikace loadujici..."),
                      CircularProgressIndicator()
                    ],
                  );
                }

                var notifications = snapshot.data!;
                if (notOption == 1) {
                  notifications = notifications
                      .where((notification) =>
                          notification.type == NotificationType.INIVTE)
                      .toList();
                } else if (notOption == 2) {
                  notifications = notifications
                      .where((notification) =>
                          notification.type == NotificationType.FOLLOW)
                      .toList();
                }

                if (notifications.isEmpty) {
                  return const Center(child: Text("Zatím žádné notifikace."));
                }

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    switch (notification.type) {
                      case NotificationType.FOLLOW:
                        return followNotification(context, notification);
                      case NotificationType.INIVTE:
                        return inviteNotification(context, notification);
                      case NotificationType.MESSAGE:
                      case NotificationType.NONE:
                      default:
                        return Container();
                    }
                  },
                );
              },
            ),
          )
        ]);
  }

  @override
  void dispose() {
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
