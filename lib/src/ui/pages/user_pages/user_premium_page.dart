import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/premuim_bloc/premium_bloc.dart';
import 'package:pofel_app/src/core/bloc/premuim_bloc/premium_event.dart';
import 'package:pofel_app/src/core/bloc/user_bloc/user_bloc.dart';
import 'package:pofel_app/src/ui/components/toast_premium_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../core/bloc/premuim_bloc/premium_state.dart';
import '../../components/snack_bar_error.dart';

class UserPremiumPage extends StatefulWidget {
  const UserPremiumPage({Key? key}) : super(key: key);

  @override
  State<UserPremiumPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<UserPremiumPage> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  @override
  Widget build(BuildContext context) {
    PremiumBloc _premiumBloc = PremiumBloc();

    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
            create: (context) => _premiumBloc,
            child: BlocListener<PremiumBloc, PremiumState>(
              listener: (context, state) {
                if (state is PremiumStateData) {
                  switch (state.premiumEnum) {
                    case PremiumEnum.PREMIUM_BOUGHT:
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBarPremiumAlert(
                              context, 'Premium koupeno! Díky ❤️'));
                      break;
                    case PremiumEnum.ERROR:
                      ScaffoldMessenger.of(context).showSnackBar(SnackBarError(
                          context, 'Chyba při nákupu :/ Napiš na @matyslav_'));
                      break;
                    default:
                      break;
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
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
                      child: Container(
                        width: double.infinity,
                        height: double.maxFinite,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 247, 190, 67),
                                Color.fromARGB(255, 245, 245, 39)
                              ],
                            )),
                        child: InkWell(
                          onTap: () {},
                          child: const Center(
                            child: Text(
                              "POFEL APP PREMIUM",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            const AutoSizeText(
                              "Zde si můžeš koupit Pofel app Premium! Vývoj téhle apky mě stál už asi 3k (Hlavně kvůli ios verzi xd) plus měsíčně platím něco za databázi. Koupí podpoříte další vývoj téhle epesní apky!",
                              maxLines: 10,
                              style: TextStyle(fontSize: 17),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            const Text("Premium features:",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                      "Epický zlatý rameček a barevná bublina ",
                                      style: TextStyle(fontSize: 15)),
                                  SizedBox(height: 5),
                                  Text(
                                      "Možnost Upgradování pofelu na premium pofel",
                                      style: TextStyle(fontSize: 15)),
                                  SizedBox(height: 5),
                                  Text(
                                      "Sdílení fotek bez ztráty kvality pro každého v premium pofelu ",
                                      style: TextStyle(fontSize: 15)),
                                  SizedBox(height: 5),
                                  Text(
                                      "Unikátní fotografie mých chodidel u tebe v dms (napiš @matyslav_)",
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            )
                          ],
                        )),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 70,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.amberAccent),
                                onPressed: () {
                                  _premiumBloc.add(const BuyPremium());
                                },
                                child: const Text("Buy premium",
                                    style: TextStyle(color: Colors.black))),
                          ),
                          const Text(
                              "Při jakýhkoliv problémech při koupi napiš na @matyslav_"),
                          ElevatedButton(
                              onPressed: () {
                                _premiumBloc.add(const RestorePurchases());
                              },
                              child: const Text("Restore purchases",
                                  style: TextStyle(color: Colors.black))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
