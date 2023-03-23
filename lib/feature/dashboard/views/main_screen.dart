import 'dart:convert';
import 'dart:io';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natv/core/app/app_style.dart';
import 'package:natv/feature/dashboard/views/success_scree.dart';

import '../bloc/ad_bloc.dart';
import '../models/channel_model.dart';
import 'channel_item.dart';
import 'multiple_date_picker.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key, required this.currentIndex});
  int currentIndex;

  @override
  State<MainScreen> createState() => _MainScreenState(currentIndex: currentIndex);
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState({required this.currentIndex});
  int currentIndex;

  Widget? list;

  double sum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
            BlocProvider.of<AdBloc>(context).add(AdTypeChanged(currentIndex == 1));
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
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: double.maxFinite,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    [TextAdWidget(), BannerAdWidget()][currentIndex],
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
                              return ChannelItemWidged(
                                model: state.model[index],
                              );
                            },
                          );

                          return list!;
                        } else if (state is ChannelLoadingError) {
                          return Column(
                            children: [
                              const Text(
                                "Channel load error",
                              ),
                              TextButton(
                                onPressed: () {
                                  BlocProvider.of<AdBloc>(context).add(FetchChannelsEvent());
                                },
                                child: const Text("Try again"),
                              )
                            ],
                          );
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
                          "Общая сумма: ${sum.toStringAsFixed(2)} сомов",
                          style: AppStyle.headLine1,
                        );
                      },
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        label: Text("Контактный номер"),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        BlocProvider.of<AdBloc>(context).add(AdPhoneChanged(phone: val));
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        label: Text("info@natv.kg"),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        BlocProvider.of<AdBloc>(context).add(AdEmailChanged(email: val));
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text("Ф.И.О./ название организации"),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        BlocProvider.of<AdBloc>(context).add(AdNameChanged(name: val));
                      },
                    ),
                    BlocConsumer<AdBloc, AdState>(
                      listener: (context, state) {
                        if (state is OrderCreateSuccess) {
                          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ЗАЯВКА ЗАРЕГИСТРИРОВАНА")));
                        } else if (state is OrderCreateError) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is OrderCreateProcessing
                              ? null
                              : () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => const SuccessScreen(),
                                    ),
                                    (route) => false,
                                  );
                                  BlocProvider.of<AdBloc>(context).add(CreateOrder());
                                },
                          child: const Text('разместить объявление'),
                        );
                      },
                    )
                  ],
                ),

                // child: [TextAdPage(), TextAdPage()][currentIndex],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextAdWidget extends StatelessWidget {
  TextAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

class BannerAdWidget extends StatefulWidget {
  BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final ImagePicker _picker = ImagePicker();
  final _cropperKey = GlobalKey(debugLabel: 'cropperKey');

  XFile? image;

  // File? _image;

  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Загрузите графический файл',
          style: AppStyle.headLine1,
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              image = await _picker.pickImage(source: ImageSource.gallery);

              BlocProvider.of<AdBloc>(context).add(ImageChangedEvent(imageBase64: base64.encode(await image!.readAsBytes())));
              setState(() {});
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Файл поврежден или не является изображением!'),
                ),
              );
            }
          },
          child: const Text('SelectImage'),
        ),
        if (image != null)
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(20.0),
            child: Cropper(
              cropperKey: _cropperKey,
              image: Image.file(File(image!.path)),
              onScaleEnd: (b) async {
                final imageBytes = await Cropper.crop(cropperKey: _cropperKey);
                BlocProvider.of<AdBloc>(context).add(ImageChangedEvent(imageBase64: base64.encode(imageBytes!)));
              },
            ),
          ),
      ],
    );
  }
}
