import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/providers/user_provider.dart';
import 'package:pofel_app/src/ui/components/review_container.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_bloc.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_event.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_state.dart';
import 'package:pofel_app/src/core/models/kyblspot_model.dart';
import 'package:pofel_app/src/core/models/kyblspot_review_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class KyblspotDetailsPage extends StatefulWidget {
  const KyblspotDetailsPage(
      {super.key, required this.model, required this.uid});

  final KyblspotModel model;
  final String uid;
  @override
  State<KyblspotDetailsPage> createState() => _KyblspotDetailsPageState();
}

class _KyblspotDetailsPageState extends State<KyblspotDetailsPage> {
  final TextEditingController _reviewController = TextEditingController();
  final UserProvider _userProvider = UserProvider();
  double _rating = 0.5;
  bool _showReviews = true;

  @override
  void initState() {
    super.initState();
    context.read<KyblspotBloc>().add(
          LoadKyblspotReviews(spotId: widget.model.spotId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: BlocBuilder<KyblspotBloc, KyblspotState>(
            builder: (context, state) {
              if (state is KyblspotLoadedState) {
                if (state.kyblspotEnum == KyblspotEnum.reviewsLoaded) {
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
                              Expanded(
                                child: Text(widget.model.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
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
                                          child: const Text(
                                            "jj",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
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
                        visible: _showReviews,
                        child: Expanded(
                          flex: 5,
                          child: ListView.builder(
                              itemCount: state.reviews.length,
                              itemBuilder: (BuildContext ctx, index) {
                                final review = state.reviews[index];
                                return Card(
                                  child: reviewContainer(
                                    context,
                                    review,
                                    currentUid: widget.uid,
                                    onDelete: () {
                                      _confirmDeleteReview(review);
                                    },
                                  ),
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
                                    _showReviews = !focused;
                                  });
                                },
                                child: TextField(
                                  controller: _reviewController,
                                  decoration: InputDecoration(
                                    labelText: 'Recenzia',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_rating.toString()),
                                  Expanded(
                                    child: Slider(
                                      value: _rating,
                                      min: 0.5,
                                      max: 5,
                                      divisions: 9,
                                      label: _rating.toString(),
                                      onChanged: (v) {
                                        setState(() {
                                          _rating = ((2 * v).round()) / 2;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _submitReview(state.reviews);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8F3BB7),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Přidat recenzi',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
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
      ),
    );
  }

  Future<void> _submitReview(List<SpotReviewModel> reviews) async {
    final reviewText = _reviewController.text.trim();
    if (reviewText.length < 10 || reviewText.length > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarError(context, 'Min 10 a max 500 písmen :/'),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString("uid");
    if (uid == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarError(context, 'Nejdřív se prosím přihlas.'),
      );
      return;
    }

    final user = await _userProvider.fetchUserData(uid);
    if (!mounted) {
      return;
    }

    final review = SpotReviewModel(
      reviewedByUid: uid,
      rating: _rating,
      review: reviewText,
      reviewedByName: user.name ?? 'Pofel user',
      isPremium: user.isPremium ?? false,
      reviewedByProfilePic: user.photo ?? '',
      reviewId: '',
    );

    context.read<KyblspotBloc>().add(
          AddReview(
            spot: widget.model,
            review: review,
            reviews: reviews,
          ),
        );

    FocusScope.of(context).unfocus();
    setState(() {
      _reviewController.clear();
      _showReviews = true;
      _rating = 0.5;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarAlert(context, 'Recenze přidána'),
    );
  }

  void _confirmDeleteReview(SpotReviewModel review) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: 'Smazat recenzi?',
      desc: 'Tvoje recenze se odstraní z tohoto kyblspotu.',
      buttons: [
        DialogButton(
          onPressed: () {
            context.read<KyblspotBloc>().add(
                  RemoveReview(
                    spot: widget.model,
                    review: review,
                  ),
                );
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarAlert(context, 'Recenze smazána'),
            );
          },
          width: 140,
          child: const Text(
            'Smazat',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
