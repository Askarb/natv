// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      id: json['id'] as int,
      channelName: json['channelName'] as String,
      logo: json['logo'] as String,
      pricePerLetter: (json['pricePerLetter'] as num).toDouble(),
      discounts: (json['discounts'] as List<dynamic>)
          .map((e) => ChannelDiscount.fromJson(e as Map<String, dynamic>))
          .toList(),
      sum: (json['sum'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'id': instance.id,
      'channelName': instance.channelName,
      'logo': instance.logo,
      'pricePerLetter': instance.pricePerLetter,
      'sum': instance.sum,
      'discounts': instance.discounts.map((e) => e.toJson()).toList(),
    };
