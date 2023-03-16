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

// class SumUpdated extends AdState {
//   final double sum;
//   SumUpdated({required this.sum});
// }

class ChannelSuccessLoaded extends AdState {
  final List<Channel> model;
  final double sum;

  ChannelSuccessLoaded({required this.model, this.sum = 0});
}
