import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../common/network/api_config.dart';
import '../../../common/network/dio_client.dart';
import '../../../di.dart';
import '../models/channel_model.dart';
import '../models/order_create_model.dart';

class ChannelRepository {
  final DioClient dioClient;

  ChannelRepository(this.dioClient);

  Future<double> calculate({required String text, required int channelId, required int dayCount}) async {
    final response = await dioClient.dio.get(
      ApiConfig.channelCalculate,
      data: {"channelId": channelId, "daysCount": dayCount, "text": text},
    );
    return response.data["priceWithDiscount"];
  }

  Future<int?> createOrder(OrderCreate model, bool isBanner) async {
    final path = isBanner ? ApiConfig.orderBannerCreate : ApiConfig.orderCreate;
    final response = await dioClient.dio.post(path, data: json.encode(model.toJson()));
    return response.statusCode;
  }

  Future<String> uploadImage(String base64_image) async {
    final response = await getIt<Dio>().post(
      'https://api.driver.kg/api/v1/ride/natv-image/',
      data: {"image": "data:image/png;base64,$base64_image"},
    );
    return response.data["url"];
  }

  Future<List<Channel>> getChannels() async {
    final response = await dioClient.dio.get(
      ApiConfig.channelList,
    );
    List<Channel> channels = [];
    if (response.data is List) {
      for (var i in response.data) {
        try {
          channels.add(Channel.fromJson(i));
        } catch (e) {}
      }
    }
    return channels;
  }
}
