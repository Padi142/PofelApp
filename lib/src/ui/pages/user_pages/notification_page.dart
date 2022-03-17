import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pofel_app/src/core/bloc/notification_bloc/notification_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_state.dart';
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
  NotificationBloc notificationBloc = NotificationBloc();
  int notOption = 0;
  @override
  Widget build(BuildContext context) {
    final notificationsQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.currentUid)
        .collection("notifications")
        .orderBy("sentOn", descending: true);

    final followsQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.currentUid)
        .collection("notifications")
        .where("type", isEqualTo: "FOLLOW")
        .orderBy("sentOn", descending: true);

    final invitesQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.currentUid)
        .collection("notifications")
        .where("type", isEqualTo: "INVITE")
        .orderBy("sentOn", descending: true);
    return BlocProvider(
      create: (context) => notificationBloc,
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
                child: (Text("Upozornění",
                    style: TextStyle(color: Colors.black87, fontSize: 17))),
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
                    child: Text("Všechno")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        notOption = 1;
                      });
                    },
                    child: Text("Pozvánky")),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        notOption = 2;
                      });
                    },
                    child: Text("Follows")),
              ],
            )),
            if (notOption == 0)
              Expanded(
                  flex: 5,
                  child: FirestoreListView(
                      pageSize: 30,
                      query: notificationsQuery,
                      itemBuilder: (context, snapshot) {
                        NotificationModel notification =
                            NotificationModel.notificationFromMap(snapshot);
                        switch (notification.type) {
                          case NotificationType.FOLLOW:
                            return followNotification(context, notification);
                          case NotificationType.INIVTE:
                            return inviteNotification(context, notification);

                          case NotificationType.MESSAGE:
                            return Container();
                          case NotificationType.NONE:
                          default:
                            return Container();
                        }
                      },
                      loadingBuilder: (context) => Column(
                            children: const [
                              Text("Notifikace loadujici..."),
                              CircularProgressIndicator()
                            ],
                          ))),
            if (notOption == 1)
              Expanded(
                  flex: 5,
                  child: FirestoreListView(
                      pageSize: 30,
                      query: invitesQuery,
                      itemBuilder: (context, snapshot) {
                        NotificationModel notification =
                            NotificationModel.notificationFromMap(snapshot);
                        return inviteNotification(context, notification);
                      },
                      loadingBuilder: (context) => Column(
                            children: const [
                              Text("Notifikace loadujici..."),
                              CircularProgressIndicator()
                            ],
                          ))),
            if (notOption == 2)
              Expanded(
                  flex: 5,
                  child: FirestoreListView(
                      pageSize: 30,
                      query: followsQuery,
                      itemBuilder: (context, snapshot) {
                        NotificationModel notification =
                            NotificationModel.notificationFromMap(snapshot);

                        return followNotification(context, notification);
                      },
                      loadingBuilder: (context) => Column(
                            children: const [
                              Text("Notifikace loadujici..."),
                              CircularProgressIndicator()
                            ],
                          )))
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
