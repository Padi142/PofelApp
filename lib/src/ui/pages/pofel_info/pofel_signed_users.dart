import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/pofe_user_container.dart';
import 'package:pofel_app/src/ui/pages/pofel_info/invite_people_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';

Widget PofelSignedUsers(BuildContext context, PofelModel pofel) {
  return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Row(
          children: [
            const Expanded(
                flex: 3, child: Text("Jméno", textAlign: TextAlign.center)),
            const Expanded(
                flex: 2,
                child: Text(
                  "Dovalí v",
                  textAlign: TextAlign.center,
                )),
            Expanded(flex: 1, child: Container())
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pofel.signedUsers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return PofelUserContainer(
                  context, pofel.signedUsers[index], pofel);
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text("Zpět"),
                  onPressed: () {
                    BlocProvider.of<PofelDetailNavigationBloc>(context)
                        .add(const PofelInfoEvent());
                  }),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  String? uid = prefs.getString("uid");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InvitePeoplePage(
                              uid: uid!,
                              pofel: pofel,
                            )),
                  );
                },
                child: const Text("Pozvat lidi"),
              ),
            )
          ],
        ),
      ]));
}
