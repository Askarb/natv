import 'package:json_annotation/json_annotation.dart';

part 'channel_model.g.dart';

@JsonSerializable()
class Channel {
  final int id;
  final String channelName;
  final String logo;
  final double pricePerLetter;
  double sum;

  Channel({
    required this.id,
    required this.channelName,
    required this.logo,
    required this.pricePerLetter,
    this.sum = 0,
  });
  factory Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
