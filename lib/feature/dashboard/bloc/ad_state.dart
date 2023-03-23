part of 'ad_bloc.dart';

@immutable
abstract class AdState {}

class AdInitial extends AdState {}

class ChannelLoading extends AdState {}

class ChannelLoadingError extends AdState {}

class AdTextError extends AdState {
  final String message;
  AdTextError({required this.message});
}

class ChannelSuccessLoaded extends AdState {
  final List<Channel> model;
  final double sum;

  ChannelSuccessLoaded({required this.model, this.sum = 0});
}

class OrderCreateSuccess extends AdState {}

class OrderCreateProcessing extends AdState {}

class OrderCreateError extends AdState {
  final String message;
  OrderCreateError({required this.message});
}
