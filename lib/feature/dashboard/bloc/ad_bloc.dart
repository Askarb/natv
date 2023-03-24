import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../models/channel_model.dart';
import '../models/order_channel_model.dart';
import '../models/order_create_model.dart';
import '../repository/channel_repository.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final ChannelRepository repository;

  final int _bannerPricePerDay = 500;

  List<Channel> channelList = [];
  OrderCreate orderCreateModel = OrderCreate();
  double sumTotal = 0;

  Timer? _debounce;
  bool _isProcessing = false;
  bool _isBanner = false;
  String? _base64image;

  Map<int, List<DateTime>> selectedDates = {};

  AdBloc({required this.repository}) : super(AdInitial()) {
    on<FetchChannelsEvent>(fetchChannels);
    on<UpdateDatesEvent>(updateDates);
    on<CalculateEvent>(calculateEvent);
    on<AdTextChanged>(adTextChanged);
    on<AdPhoneChanged>(adPhoneChanged);
    on<AdEmailChanged>(adEmailChanged);
    on<AdNameChanged>(adNameChanged);
    on<CreateOrder>(createOrder);
    on<ClearData>(clear);
    on<ImageChangedEvent>(imageChanged);
    on<AdTypeChanged>(adTypeChange);
  }
  adTypeChange(event, emit) {
    _isBanner = event.isBanner;
    // calculateEvent(event, emit);
    _recalculate();
  }

  clear(event, emit) {
    for (var i in channelList) {
      i.sum = 0;
    }
    selectedDates = {};
    sumTotal = 0;
    _base64image = null;
    emit(ChannelSuccessLoaded(model: channelList, sum: sumTotal));
  }

  createOrder(event, emit) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(OrderCreateProcessing());

    String error = 'Упс, что то пошло не так(';

    orderCreateModel.channels = [];
    selectedDates.forEach(
      (key, value) {
        if (value.isNotEmpty) {
          orderCreateModel.channels.add(
            OrderChannel(
              channelId: key,
              days: List<int>.generate(
                value.length,
                (index) => getCountDay(value[index]),
              ),
            ),
          );
        }
      },
    );

    if (orderCreateModel.channels.isEmpty) {
      error = "Выберите даты";
    } else if (!textIsValid() && !_isBanner) {
      error = "Введите текст";
    } else if (_base64image == null && _isBanner) {
      error = "Выберите фото";
    } else {
      try {
        if (_isBanner) {
          orderCreateModel.path = await repository.uploadImage(_base64image!);
        }
        final response = await repository.createOrder(orderCreateModel, _isBanner);

        if (response == 200) {
          emit(OrderCreateSuccess());
          _isProcessing = false;
          return;
        }
      } catch (e) {}
    }

    emit(OrderCreateError(message: error));
    _isProcessing = false;
  }

  calculateEvent(event, emit) async {
    sumTotal = 0;
    for (int i = 0; i < channelList.length; i++) {
      if (channelList[i].id == event.id) {
        channelList[i].sum = await calculate(channelId: event.id, dayCount: selectedDates[event.id]?.length ?? 0);
      }

      sumTotal += channelList[i].sum;
    }
    emit(ChannelSuccessLoaded(model: channelList, sum: sumTotal));
  }

  Future<double> calculate({required int channelId, required int dayCount}) async {
    if (dayCount == 0 || !textIsValid() && !_isBanner || _isBanner && _base64image == null) {
      return 0;
    }
    if (_isBanner) {
      return (dayCount * _bannerPricePerDay).toDouble();
    }
    return await repository.calculate(text: orderCreateModel.text, channelId: channelId, dayCount: selectedDates[channelId]?.length ?? 0);
  }

  updateDates(event, emit) {
    selectedDates[event.id] = event.dates;
  }

  adPhoneChanged(event, emit) {
    orderCreateModel.clientPhone = event.phone;
  }

  adEmailChanged(event, emit) {
    orderCreateModel.clientEmail = event.email;
  }

  adNameChanged(event, emit) {
    orderCreateModel.clientFIO = event.name;
  }

  adTextChanged(event, emit) {
    orderCreateModel.text = event.text;

    if (!textIsValid()) {
      emit(AdTextError(message: "должен содержать не менее 20 символов!"));
    } else {
      emit(AdTextError(message: ""));
      _recalculate();
    }
  }

  _recalculate() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () async {
      sumTotal = 0;
      for (int i = 0; i < channelList.length; i++) {
        channelList[i].sum = await calculate(channelId: channelList[i].id, dayCount: selectedDates[channelList[i].id]?.length ?? 0);
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

  int getCountDay(date) {
    return date.difference(DateTime(1970, 1, 1, 0, 0)).inDays;
  }

  bool textIsValid() {
    return orderCreateModel.text.length >= 20;
  }

  imageChanged(event, emit) {
    _base64image = event.imageBase64;
    _recalculate();
  }
}
