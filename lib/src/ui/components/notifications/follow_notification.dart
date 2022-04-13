import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';

Widget followNotification(
    BuildContext context, NotificationModel notification) {
  SocialBloc socialBloc = SocialBloc();
  return BlocProvider(
    create: (context) => socialBloc,
    child: Container(
      margin: const EdgeInsets.all(3),
      decoration: const BoxDecoration(color: Colors.blueGrey),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: CircleAvatar(
                      radius: 30,
                      foregroundImage:
                          NetworkImage((notification.sentByProfilePic)),
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
                  socialBloc.add(Follow(userId: notification.userId));
                },
                child: const Text("Sledovat zpátky"),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
