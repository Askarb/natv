// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_discount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelDiscount _$ChannelDiscountFromJson(Map<String, dynamic> json) =>
    ChannelDiscount(
      discount: json['discount'] as int,
      fromDaysCount: json['fromDaysCount'] as int,
    );

Map<String, dynamic> _$ChannelDiscountToJson(ChannelDiscount instance) =>
    <String, dynamic>{
      'discount': instance.discount,
      'fromDaysCount': instance.fromDaysCount,
    };
