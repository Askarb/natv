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

class AdPhoneChanged extends AdEvent {
  final String phone;
  AdPhoneChanged({required this.phone});
}

class AdEmailChanged extends AdEvent {
  final String email;
  AdEmailChanged({required this.email});
}

class AdNameChanged extends AdEvent {
  final String name;
  AdNameChanged({required this.name});
}

class ImageChangedEvent extends AdEvent {
  final String imageBase64;
  ImageChangedEvent({required this.imageBase64});
}

class CreateOrder extends AdEvent {
  CreateOrder();
}

class AdTypeChanged extends AdEvent {
  final bool isBanner;
  AdTypeChanged(this.isBanner);
}

class ClearData extends AdEvent {
  ClearData();
}
