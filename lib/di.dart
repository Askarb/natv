import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'common/network/dio_client.dart';
import 'feature/dashboard/bloc/ad_bloc.dart';
import 'feature/dashboard/repository/channel_repository.dart';

// final getIt = GetIt.instance;
final getIt = GetIt.instance;

Future<void> _initSharedPref() async {
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // getIt.registerSingleton<SharedPreferences>(pref);
}

void _initSession() {
  // final session = SessionImpl(getIt<SharedPreferences>());
  // getIt.registerSingleton<Session>(session);
}

Future<void> init() async {
  // await _initSharedPref();
  // _initSession();

  //City
  // getIt.registerLazySingleton<CityRepository>(() => CityRepository(getIt<DioClient>()));
  // //City
  // // getIt.registerLazySingleton<LoginRepository>(() => LoginRepository(getIt<DioClient>()));
  // // getIt.registerLazySingleton<LoginBloc>(() => LoginBloc(repository: getIt<LoginRepository>()));

  // //Registration
  // getIt.registerLazySingleton<RegistrationRepository>(() => RegistrationRepository(getIt<DioClient>()));

  // getIt.registerLazySingleton<RegistrationBloc>(() => RegistrationBloc(repository: getIt()));
  // getIt.registerLazySingleton<UserDataBloc>(() => UserDataBloc(repository: getIt()));

  // getIt.registerLazySingleton<OrderBloc>(() => OrderBloc());
  // getIt.registerLazySingleton<CityBloc>(() => CityBloc(repository: getIt()));
  // //Login
  getIt.registerFactory(() => ChannelRepository(getIt<DioClient>()));
  getIt.registerLazySingleton<AdBloc>(() => AdBloc(repository: getIt()));

  //Dio
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<Dio>()));
  getIt.registerLazySingleton<Dio>(() => Dio());
}
