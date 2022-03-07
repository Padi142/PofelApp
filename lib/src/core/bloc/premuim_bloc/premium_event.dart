import 'package:equatable/equatable.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object> get props => [];
}

class BuyPremium extends PremiumEvent {
  const BuyPremium();

  @override
  List<Object> get props => [];
}

class ProductBought extends PremiumEvent {
  const ProductBought();

  @override
  List<Object> get props => [];
}

class RestorePurchases extends PremiumEvent {
  const RestorePurchases();

  @override
  List<Object> get props => [];
}
