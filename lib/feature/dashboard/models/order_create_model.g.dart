// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderCreate _$OrderCreateFromJson(Map<String, dynamic> json) => OrderCreate(
      text: json['text'] as String? ?? '',
      clientPhone: json['clientPhone'] as String? ?? '',
      clientEmail: json['clientEmail'] as String? ?? '',
      clientFIO: json['clientFIO'] as String? ?? '',
      channels: (json['channels'] as List<dynamic>)
          .map((e) => OrderChannel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderCreateToJson(OrderCreate instance) =>
    <String, dynamic>{
      'text': instance.text,
      'clientPhone': instance.clientPhone,
      'clientEmail': instance.clientEmail,
      'clientFIO': instance.clientFIO,
      'channels': instance.channels.map((e) => e.toJson()).toList(),
    };
