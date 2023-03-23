import 'package:json_annotation/json_annotation.dart';

import 'order_channel_model.dart';

part 'order_create_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderCreate {
  String text;
  String path;
  String clientPhone;
  String clientEmail;
  String clientFIO;
  List<OrderChannel> channels;

  OrderCreate({
    this.text = '',
    this.path = '',
    this.clientPhone = '',
    this.clientEmail = '',
    this.clientFIO = '',
    List<OrderChannel>? channels,
  }) : channels = channels ?? [];
  factory OrderCreate.fromJson(Map<String, dynamic> json) => _$OrderCreateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderCreateToJson(this);
}
