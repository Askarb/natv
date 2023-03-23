import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di.dart';
import 'feature/dashboard/bloc/ad_bloc.dart';
import 'feature/dashboard/views/main_screen.dart';

void main() async {
  runApp(MyApp());

  await init();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdBloc>(create: (context) => getIt<AdBloc>()),
        // BlocProvider<UserDataBloc>(create: (context) => getIt<UserDataBloc>()),
        // BlocProvider<CityBloc>(create: (context) => getIt<CityBloc>()),
        // BlocProvider<LoginBloc>(create: (context) => getIt<LoginBloc>()),
        // BlocProvider<RegistrationBloc>(create: (context) => getIt<RegistrationBloc>()),
        // BlocProvider(
        //   create: (context) => RegistrationBloc(
        //     repository: RepositoryProvider.of<RegistrationRepository>(context),
        //   ),
        // ),
        // BlocProvider(
        //   create: (context) => UserDataBloc(
        //     repository: RepositoryProvider.of<SetuserDataRepository>(context),
        //   ),
        // ),
        // BlocProvider(
        //   create: (context) => LoginBloc(
        //     repository: RepositoryProvider.of<LoginRepository>(context),
        //   ),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: AuthScreen(),
        home: MainScreen(
          currentIndex: 0,
        ),
      ),
    );
  }
}
