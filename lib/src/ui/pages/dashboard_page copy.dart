import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text("Profil")]);
  }
}
