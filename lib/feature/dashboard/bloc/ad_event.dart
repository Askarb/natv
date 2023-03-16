part of 'ad_bloc.dart';

@immutable
abstract class AdEvent {}

class FetchChannelsEvent extends AdEvent {
  FetchChannelsEvent();
}

class UpdateDatesEvent extends AdEvent {
  final int id;
  final List<DateTime> dates;
  UpdateDatesEvent({required this.id, required this.dates});
}

class CalculateEvent extends AdEvent {
  final int id;
  CalculateEvent({required this.id});
}

class AdTextChanged extends AdEvent {
  final String text;
  AdTextChanged({required this.text});
}
