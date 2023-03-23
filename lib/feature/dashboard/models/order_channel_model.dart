import 'package:json_annotation/json_annotation.dart';

import 'channel_discount_model.dart';

part 'order_channel_model.g.dart';

@JsonSerializable()
class OrderChannel {
  final int channelId;
  final List<int> days;

  OrderChannel({
    required this.channelId,
    required this.days,
  });
  factory OrderChannel.fromJson(Map<String, dynamic> json) => _$OrderChannelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderChannelToJson(this);
}
