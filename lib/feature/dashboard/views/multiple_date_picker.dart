import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natv/core/app/app_style.dart';
import 'package:natv/feature/dashboard/bloc/ad_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/channel_discount_model.dart';

class MultipleDatePicker extends StatelessWidget {
  MultipleDatePicker({
    super.key,
    required this.onChanged,
    required this.callbackCalculate,
    required this.discount,
    this.selectedDates,
  });
  final Function(List<DateTime>) onChanged;
  final Function() callbackCalculate;
  List<DateTime>? selectedDates;
  List<ChannelDiscount> discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (discount.isNotEmpty) ...[
                Column(
                  children: [
                    const Text('При заказе на данном телеканале действует система скидок:'),
                    for (var i in discount) ...[Text("от ${i.fromDaysCount} дн. - скидка  ${i.discount}%")],
                  ],
                ),
              ],
              const Text(
                "Выберите даты",
                style: AppStyle.headLine1,
              ),
              SizedBox(
                child: SfDateRangePicker(
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    onChanged(args.value);
                  },
                  selectionMode: DateRangePickerSelectionMode.multiple,
                  minDate: DateTime.now(),
                  maxDate: DateTime.now().add(
                    const Duration(
                      days: 100,
                    ),
                  ),
                  initialSelectedDates: selectedDates,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  callbackCalculate();
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
