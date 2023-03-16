import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:natv/core/app/app_style.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../bloc/ad_bloc.dart';
import '../models/channel_model.dart';
import 'multiple_date_picker.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'Строчная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Баннерная',
          ),
        ],
      ),
      body: SafeArea(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.all(20),
            // child: [TextAdPage(), TextAdPage()][currentIndex],

            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: [TextAdPage(), TextAdPage()][currentIndex],
            ),
          ),
        ),
      ),
    );
  }
}

class TextAdPage extends StatelessWidget {
  TextAdPage({super.key});

  Widget? list;

  double sum = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Размещение строчного объявления',
          style: AppStyle.headLine1,
        ),
        BlocBuilder<AdBloc, AdState>(
          builder: (context, state) {
            String error = '';
            if (state is AdTextError) {
              error = state.message;
            }
            return TextField(
              minLines: 10,
              maxLines: 20,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Введите текст объявления',
                errorText: error,
              ),
              onChanged: (val) {
                BlocProvider.of<AdBloc>(context).add(AdTextChanged(text: val));
              },
            );
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Выбор каналов',
          style: AppStyle.headLine1,
        ),
        BlocBuilder<AdBloc, AdState>(
          builder: (context, state) {
            if (state is AdInitial) {
              BlocProvider.of<AdBloc>(context).add(FetchChannelsEvent());
            }

            if (state is ChannelSuccessLoaded) {
              list = ListView.builder(
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.model.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text('sdfsdf');
                  return ChannelItem(
                    model: state.model[index],
                  );
                },
              );

              return list!;
            }
            return list ?? const CircularProgressIndicator();
          },
        ),
        BlocBuilder<AdBloc, AdState>(
          builder: (context, state) {
            if (state is ChannelSuccessLoaded) {
              sum = state.sum;
            }
            return Text(
              "Общая сумма: $sum сомов",
              style: AppStyle.headLine1,
            );
          },
        ),
        TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            label: Text("Контактный номер"),
            border: const OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Submit'),
        )
      ],
    );
  }
}

class ChannelItem extends StatefulWidget {
  const ChannelItem({
    super.key,
    required this.model,
  });
  final Channel model;

  @override
  State<ChannelItem> createState() => _ChannelItemState();
}

class _ChannelItemState extends State<ChannelItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Image.network(
              widget.model.logo,
              errorBuilder: (context, error, stackTrace) {
                return const Text("LogoError");
              },
            ),
          ),
          const Spacer(),
          Text(widget.model.channelName),
          const Spacer(),
          SizedBox(
            // width: 80,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultipleDatePicker(
                      onChanged: (List<DateTime> dates) {
                        BlocProvider.of<AdBloc>(context).add(
                          UpdateDatesEvent(
                            id: widget.model.id,
                            dates: dates,
                          ),
                        );
                      },
                      callbackCalculate: () {
                        BlocProvider.of<AdBloc>(context).add(
                          CalculateEvent(
                            id: widget.model.id,
                          ),
                        );
                      },
                      selectedDates: BlocProvider.of<AdBloc>(context).selectedDates[widget.model.id],
                    ),
                  ),
                );
              },
              child: const Text('Select Dates'),
            ),
          ),
          Text('${widget.model.sum} сом'),
        ],
      ),
    );
  }
}
