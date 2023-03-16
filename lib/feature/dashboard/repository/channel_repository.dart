import '../../../common/network/api_config.dart';
import '../../../common/network/dio_client.dart';
import '../models/channel_model.dart';

class ChannelRepository {
  final DioClient dioClient;

  ChannelRepository(this.dioClient);

  Future<double> calculate({required String text, required int channelId, required int dayCount}) async {
    final response = await dioClient.dio.get(
      ApiConfig.channelCalculate,
      data: {"channelId": channelId, "daysCount": dayCount, "text": text},
    );
    return response.data["price"];
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
