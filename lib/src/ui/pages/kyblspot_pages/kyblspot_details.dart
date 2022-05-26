import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/ui/components/review_container.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_bloc.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_event.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_state.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:pofel_app/src/core/models/kyblspot_review_model.dart';

import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KyblspotDetailsPage extends StatefulWidget {
  KyblspotDetailsPage({Key? key, required this.model, required this.uid})
      : super(key: key);

  final KyblspotModel model;
  final String uid;
  @override
  _KyblspotDetailsPageState createState() => _KyblspotDetailsPageState();
}

double value = 0.5;
bool showReviews = true;
String recenzia = "";
final myController = TextEditingController();

class _KyblspotDetailsPageState extends State<KyblspotDetailsPage> {
  @override
  Widget build(BuildContext context) {
    myController.text = recenzia;

    BlocProvider.of<KyblspotBloc>(context).add(LoadKyblspotReviews(
      spotId: widget.model.spotId,
    ));
    return FocusWatcher(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Center(
              child: BlocBuilder<KyblspotBloc, KyblspotState>(
                builder: (context, state) {
                  if (state is KyblspotLoadedState) {
                    if (state.kyblspotEnum == KyblspotEnum.REVIEWS_LOADED) {
                      return Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 8),
                            child: Column(children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(Icons.arrow_back_ios)),
                                  Text(widget.model.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  if (widget.model.createdBy == widget.uid)
                                    ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                      onPressed: () {
                                        Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: "FR?",
                                          content: Column(
                                            children: const [],
                                          ),
                                          buttons: [
                                            DialogButton(
                                              child: const Text(
                                                "jj",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              onPressed: () {
                                                BlocProvider.of<KyblspotBloc>(
                                                        context)
                                                    .add(RemoveSpot(
                                                  spot: widget.model,
                                                ));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBarAlert(
                                                        context, 'Smazar!'));
                                                Navigator.pop(context);
                                              },
                                              width: 120,
                                            )
                                          ],
                                        ).show();
                                      },
                                      child: const Text("smazat"),
                                    )
                                ],
                              ),
                            ]),
                          ),
                          Visibility(
                            visible: showReviews,
                            child: Expanded(
                              flex: 5,
                              child: ListView.builder(
                                  itemCount: state.reviews.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return Card(
                                      child: reviewContainer(
                                          context, state.reviews[index]),
                                    );
                                  }),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 10, bottom: 5),
                              child: Column(
                                children: [
                                  Focus(
                                    onFocusChange: (focused) {
                                      setState(() {
                                        showReviews = !showReviews;
                                      });
                                    },
                                    child: TextField(
                                      onChanged: (text) {
                                        recenzia = text;
                                      },
                                      controller: myController,
                                      decoration: InputDecoration(
                                        labelText: 'Recenzia',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(value.toString()),
                                      SmoothStarRating(
                                          allowHalfRating: true,
                                          onRatingChanged: (v) {
                                            value = ((2 * v).round()) / 2;
                                            if (value < 0.5) {
                                              value = 0.5;
                                            }
                                            setState(() {});
                                          },
                                          starCount: 5,
                                          rating: value,
                                          size: 40.0,
                                          color: Colors.yellow,
                                          borderColor: Colors.yellow,
                                          spacing: 0.0),
                                    ],
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (myController.text.length > 5 &&
                                              myController.text.length < 500) {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? uid =
                                                prefs.getString("uid");

                                            SpotReviewModel review =
                                                SpotReviewModel(
                                                    reviewedByUid: uid!,
                                                    rating: value,
                                                    review: myController.text,
                                                    reviewedByName: "",
                                                    isPremium: false,
                                                    reviewedByProfilePic: '',
                                                    reviewId: '');
                                            BlocProvider.of<KyblspotBloc>(
                                                    context)
                                                .add(AddReview(
                                                    spot: widget.model,
                                                    review: review,
                                                    reviews: state.reviews));
                                            myController.text = "";
                                            recenzia = "";
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBarError(
                                                    context,
                                                    'Min 10 a max 500 pismen :/'));
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Přidat recenzi',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF8F3BB7),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          )),
    );
  }
}
