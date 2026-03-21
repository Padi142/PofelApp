import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pofel_app/src/core/bloc/premuim_bloc/premium_event.dart';
import 'package:pofel_app/src/core/bloc/premuim_bloc/premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  PremiumBloc() : super(PremiumInitial()) {
    on<BuyPremium>(_onBuyPremium);
    on<ProductBought>(_onProductBought);
    on<RestorePurchases>(_onRestorePurchases);
  }

  _onBuyPremium(BuyPremium event, Emitter<PremiumState> emit) async {
    emit(PremiumStateData(premiumEnum: PremiumEnum.ERROR));
  }

  _onProductBought(ProductBought event, Emitter<PremiumState> emit) async {
    emit(PremiumStateData(premiumEnum: PremiumEnum.ERROR));
  }

  _onRestorePurchases(
      RestorePurchases event, Emitter<PremiumState> emit) async {
    emit(PremiumStateData(premiumEnum: PremiumEnum.ERROR));
  }
}
