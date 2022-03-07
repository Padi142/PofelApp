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
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../core/bloc/premuim_bloc/premium_state.dart';

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

    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList, _premiumBloc);
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>?;
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
            create: (context) => _premiumBloc,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
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
                            style: TextStyle(color: Colors.white, fontSize: 25),
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
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Epický zlatý rameček a barevná bublina ",
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 5),
                                Text(
                                    "Možnost Upgradování pofelu na premium pofel (in progress)",
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 5),
                                Text(
                                    "Sdílení fotek bez ztráty kvality pro každého v premium pofelu (in progress)",
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
            )),
      ),
    );
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList, PremiumBloc bloc) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //_showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //_handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.status == PurchaseStatus.purchased) {
            bloc.add(const ProductBought());
          } else {
            // _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }
}
