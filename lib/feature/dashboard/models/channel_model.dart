import 'package:json_annotation/json_annotation.dart';

import 'channel_discount_model.dart';

part 'channel_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Channel {
  final int id;
  final String channelName;
  final String logo;
  final double pricePerLetter;
  double sum;
  List<ChannelDiscount> discounts;

  Channel({
    required this.id,
    required this.channelName,
    required this.logo,
    required this.pricePerLetter,
    required this.discounts,
    this.sum = 0,
  });
  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
