import 'package:json_annotation/json_annotation.dart';

part 'channel_discount_model.g.dart';

@JsonSerializable()
class ChannelDiscount {
  final int discount;
  final int fromDaysCount;

  ChannelDiscount({
    required this.discount,
    required this.fromDaysCount,
  });
  factory ChannelDiscount.fromJson(Map<String, dynamic> json) => _$ChannelDiscountFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelDiscountToJson(this);
}
