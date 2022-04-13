import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_state.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:pofel_app/src/ui/components/follower_container.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserFollowersPage extends StatefulWidget {
  UserFollowersPage({Key? key, required this.profiles}) : super(key: key);
  final List<ProfileModel> profiles;

  @override
  State<UserFollowersPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<UserFollowersPage> {
  final myController = TextEditingController();
  SocialBloc socialBloc = SocialBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => socialBloc,
          child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Zpět")),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.profiles.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FollowerContainer(context, widget.profiles[index]);
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}
