import 'dart:async';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_flutter/models/adapty_error.dart';
import 'package:adapty_flutter/models/adapty_error.dart';
import 'package:adapty_flutter/models/adapty_paywall.dart';
import 'package:adapty_flutter/models/adapty_product.dart';
import 'package:adapty_flutter/results/get_paywalls_result.dart';
import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:adapty_flutter/results/restore_purchases_result.dart';
import 'package:bloc/bloc.dart';
import 'package:pofel_app/src/core/bloc/premuim_bloc/premium_event.dart';
import 'package:pofel_app/src/core/bloc/premuim_bloc/premium_state.dart';
import 'package:pofel_app/src/core/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  PremiumBloc() : super(PremiumInitial()) {
    on<BuyPremium>(_onBuyPremium);
    on<ProductBought>(_onProductBought);
    on<RestorePurchases>(_onRestorePurchases);
  }

  UserProvider userProvider = UserProvider();
  _onBuyPremium(BuyPremium event, Emitter<PremiumState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    AdaptyPaywall? myPaywall;

    try {
      final GetPaywallsResult getPaywallsResult =
          await Adapty.getPaywalls(forceUpdate: false);
      List<AdaptyPaywall>? paywalls = getPaywallsResult.paywalls;

      myPaywall = paywalls!
          .firstWhere((paywall) => paywall.developerId == "PofelAppPremium");
      final AdaptyProduct? product = myPaywall.products!.first;

      final MakePurchaseResult makePurchaseResult =
          await Adapty.makePurchase(product!);
      // "premium" is an identifier of default access level
      if (makePurchaseResult.purchaserInfo?.accessLevels['premium']!.isActive ??
          false) {
        await userProvider.buyPremium(uid!);
        emit(PremiumStateData(premiumEnum: PremiumEnum.PREMIUM_BOUGHT));
      }
    } on AdaptyError catch (adaptyError) {
      print(adaptyError);
      emit(PremiumStateData(premiumEnum: PremiumEnum.ERROR));
    }
  }

  _onProductBought(ProductBought event, Emitter<PremiumState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");

    await userProvider.buyPremium(uid!);
    print("premium bought");
  }

  _onRestorePurchases(
      RestorePurchases event, Emitter<PremiumState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    try {
      final RestorePurchasesResult restorePurchasesResult =
          await Adapty.restorePurchases();

      // "premium" is an identifier of default access level
      if (restorePurchasesResult
              .purchaserInfo?.accessLevels['premium']!.isActive ??
          false) {
        await userProvider.buyPremium(uid!);
        emit(PremiumStateData(premiumEnum: PremiumEnum.PREMIUM_BOUGHT));
      }
    } on AdaptyError catch (adaptyError) {
      print(adaptyError);
      emit(PremiumStateData(premiumEnum: PremiumEnum.ERROR));
    }
  }
}
