import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natv/feature/dashboard/views/main_screen.dart';

import '../bloc/ad_bloc.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  goToMainScreen(bool isBanner, BuildContext context) {
    BlocProvider.of<AdBloc>(context).add(ClearData());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MainScreen(currentIndex: isBanner ? 1 : 0),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = BlocProvider.of<AdBloc>(context).orderCreateModel.path;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const Text("ЗАЯВКА ЗАРЕГИСТРИРОВАНА"),
            Text("СТОИМОСТЬ ОБЪЯВЛЕНИЯ ${BlocProvider.of<AdBloc>(context).sumTotal.toStringAsFixed(2)} сом"),
            if (image != '') ...[Image.network(image)],
            ElevatedButton(
              onPressed: () {
                goToMainScreen(false, context);
              },
              child: const Text('Разместить еще объявления'),
            ),
            ElevatedButton(
              onPressed: () {
                goToMainScreen(true, context);
              },
              child: const Text('или разместить баннерную рекламу'),
            ),
          ],
        ),
      )),
    );
  }
}
