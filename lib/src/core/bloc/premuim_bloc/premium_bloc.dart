import 'dart:async';

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
    final bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      await userProvider.buyPremium(uid!);

      emit(PremiumStateData(premiumEnum: PremiumEnum.PREMIUM_BOUGHT));

      const Set<String> _kIds = <String>{'pofelapp_premium'};
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }
      List<ProductDetails> products = response.productDetails;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: products[0]);

      InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
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
    await InAppPurchase.instance.restorePurchases();
  }
}
