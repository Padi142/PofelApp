import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';

Widget inviteNotification(
    BuildContext context, NotificationModel notification) {
  return Container(
    margin: const EdgeInsets.all(3),
    decoration: const BoxDecoration(color: Colors.blueGrey),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: CircleAvatar(
                    radius: 30,
                    foregroundImage: NetworkImage(
                        ("https://firebasestorage.googleapis.com/v0/b/pofelapp-420.appspot.com/o/logos%2Fic_launcher.png?alt=media&token=53d62cb7-8072-4e4c-94a8-d75c3b171898")),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(notification.message,
                        maxLines: 12, style: const TextStyle(fontSize: 17)),
                  )),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<PofelBloc>(context)
                    .add(JoinPofel(joinId: notification.pofelId));
                BlocProvider.of<LoadpofelsBloc>(context)
                    .add(const LoadMyPofels());
              },
              child: const Text("Připojit k pofelu"),
            ),
          ),
        ),
      ],
    ),
  );
}
