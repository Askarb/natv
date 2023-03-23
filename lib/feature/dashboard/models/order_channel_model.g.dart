// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderChannel _$OrderChannelFromJson(Map<String, dynamic> json) => OrderChannel(
      channelId: json['channelId'] as int,
      days: (json['days'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$OrderChannelToJson(OrderChannel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'days': instance.days,
    };
