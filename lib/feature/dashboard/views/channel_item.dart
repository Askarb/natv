import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ad_bloc.dart';
import '../models/channel_model.dart';
import 'multiple_date_picker.dart';

class ChannelItemWidged extends StatefulWidget {
  const ChannelItemWidged({
    super.key,
    required this.model,
  });
  final Channel model;

  @override
  State<ChannelItemWidged> createState() => _ChannelItemWidgedState();
}

class _ChannelItemWidgedState extends State<ChannelItemWidged> {
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
            width: 80,
            child: Image.network(
              widget.model.logo,
              errorBuilder: (context, error, stackTrace) {
                return const Text("Logo");
              },
            ),
          ),
          const Spacer(),
          Text(widget.model.channelName),
          const Spacer(),
          SizedBox(
            // width: 80,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultipleDatePicker(
                      discount: widget.model.discounts,
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
              icon: const Icon(Icons.calendar_month),
            ),
          ),
          Text('${widget.model.sum} сом'),
        ],
      ),
    );
  }
}
