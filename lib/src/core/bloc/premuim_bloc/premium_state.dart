import 'package:equatable/equatable.dart';

abstract class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object> get props => [];
}

class PremiumInitial extends PremiumState {}

class PremiumStateData extends PremiumState {
  PremiumEnum premiumEnum;
  PremiumStateData({required this.premiumEnum});

  @override
  List<Object> get props => [premiumEnum];
}

enum PremiumEnum { NONE, PREMIUM_BOUGHT }
