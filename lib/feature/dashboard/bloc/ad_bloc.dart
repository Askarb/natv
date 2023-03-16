import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../models/channel_model.dart';
import '../repository/channel_repository.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final ChannelRepository repository;

  List<Channel> channelList = [];
  String adText = '';
  double sumTotal = 0;

  Timer? _debounce;

  Map<int, List<DateTime>> selectedDates = {};

  AdBloc({required this.repository}) : super(AdInitial()) {
    on<FetchChannelsEvent>(fetchChannels);
    on<UpdateDatesEvent>(updateDates);
    on<CalculateEvent>(calculateEvent);
    on<AdTextChanged>(adTextChanged);
  }

  calculateEvent(event, emit) async {
    if (adText.length < 20) return;
    sumTotal = 0;
    for (int i = 0; i < channelList.length; i++) {
      if (channelList[i].id == event.id) {
        channelList[i].sum = await repository.calculate(text: adText, channelId: event.id, dayCount: selectedDates[event.id]?.length ?? 0);
      }

      sumTotal += channelList[i].sum;
    }
    emit(ChannelSuccessLoaded(model: channelList, sum: sumTotal));
  }

  updateDates(event, emit) {
    selectedDates[event.id] = event.dates;
  }

  adTextChanged(event, emit) {
    adText = event.text;
    if (adText.length < 20) {
      emit(AdTextError(message: "Текст объявления должен содержать не менее 20 символов!"));
    } else {
      emit(AdTextError(message: ""));
      _onSearchChanged('');
    }
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      print("#########################sdfsdf");

      if (adText.length < 20) return;
      sumTotal = 0;
      for (int i = 0; i < channelList.length; i++) {
        channelList[i].sum =
            await repository.calculate(text: adText, channelId: channelList[i].id, dayCount: selectedDates[channelList[i].id]?.length ?? 0);
        sumTotal += channelList[i].sum;
      }
      emit(ChannelSuccessLoaded(model: channelList, sum: sumTotal));
    });
  }

  fetchChannels(event, emit) async {
    try {
      channelList = await repository.getChannels();

      emit(ChannelSuccessLoaded(model: channelList));
    } catch (e) {
      String message = 'Упс, что то пошло не так(';
      // if (e is DioError) {
      //   message = e.response?.data?['detail'] ?? message;
      // }
      emit(ChannelLoadingError());
    }
  }
}
