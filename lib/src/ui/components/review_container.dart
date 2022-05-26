import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/models/kyblspot_review_model.dart';
import 'package:pofel_app/src/core/models/message_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget reviewContainer(BuildContext context, SpotReviewModel review) {
  if (review.isPremium) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        onLongPress: () {
          String text = review.rating.toString() + "/5 : " + review.review;

          Clipboard.setData(ClipboardData(
            text: text,
          ));
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBarAlert(context, 'Zkopírováno'));
        },
        highlightColor: Colors.grey,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFf5f5f5),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(review.reviewedByName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        PofelUserModel user = PofelUserModel(
                            acceptedInvitation: true,
                            joinedOn: DateTime.now(),
                            chatNotification: true,
                            isPremium: true,
                            name: review.reviewedByName,
                            photo: review.reviewedByProfilePic,
                            uid: review.reviewedByUid,
                            willArrive: DateTime.now());

                        alert(context, user).show();
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            foregroundImage:
                                NetworkImage(review.reviewedByProfilePic),
                          ),
                          const Text("Premium",
                              style: TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                    RatingStars(
                        value: review.rating, starCount: 5, starSize: 27),
                  ],
                ),
                Text(review.review),
              ],
            ),
          ),
        ),
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        onLongPress: () {
          String text = review.rating.toString() + "/5 : " + review.review;

          Clipboard.setData(ClipboardData(
            text: text,
          ));
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBarAlert(context, 'Zkopírováno'));
        },
        highlightColor: Colors.grey,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFf5f5f5),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 4,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      foregroundImage:
                          NetworkImage(review.reviewedByProfilePic),
                    ),
                    RatingStars(
                        value: review.rating, starCount: 5, starSize: 27),
                  ],
                ),
                Text(review.review),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Alert alert(
  BuildContext context,
  PofelUserModel user,
) {
  return Alert(
    context: context,
    type: AlertType.none,
    title: user.name,
    content: Container(
      color: user.isPremium == true
          ? const Color.fromARGB(255, 247, 190, 67)
          : Colors.white,
      child: Column(
        children: [
          Image.network(
            user.photo,
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          Row(
            children: const [],
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<SocialBloc>(context)
                  .add(Follow(userId: user.uid));
              Navigator.pop(context);
            },
            child: const Text("Follow"),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
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
