import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:poca/screens/admin/admin_channels.dart';

import '../../../configs/constants.dart';
import '../../../models/channel_model.dart';
import '../../../models/topic.dart';
import '../../../providers/api/api_channel.dart';
import '../../../providers/api/api_topic.dart';
import '../../../services/cloud_service.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_progress.dart';
import '../../../widgets/network_image_custom.dart';

class AdCreateChannelScreen extends StatelessWidget {
  const AdCreateChannelScreen({super.key, required this.adminChannelsCubit});
  final AdminChannelsCubit adminChannelsCubit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: purpleColor),
        centerTitle: true,
        title: Builder(builder: (context) {
          var text = 'Create Channel';
          return Text(
            text,
            style: const TextStyle(
                color: purpleColor, fontWeight: FontWeight.bold),
          );
        }),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => AdCreateChannelCubit()..load(),
          child: BlocBuilder<AdCreateChannelCubit, int>(
            builder: (context, state) {
              if (state == 0) return const LoadingProgress();
              final cubit = context.read<AdCreateChannelCubit>();
              final items = cubit.listTopic
                  .map((e) => MultiSelectItem<Topic>(e, e.name))
                  .toList();
              var baseImage = 'https://cdn5.vectorstock.com/i/1000x1000/64/49/girl-listening-in-headset-avatar-round-icon-vector-28486449.jpg';
              return Center(
                child: Form(
                  key: cubit._formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      cubit.image == null
                          ? NetworkImageCustom(
                        url: baseImage,
                        borderRadius: BorderRadius.circular(1000),
                        width: Resizable.size(context, 220),
                        height: Resizable.size(context, 220),
                      )
                          : Container(
                        width: Resizable.size(context, 220),
                        height: Resizable.size(context, 220),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: cubit.image == null
                                ? null
                                : DecorationImage(
                                image: FileImage(
                                    File(cubit.image!.path)),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(1000)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            debugPrint(image!.path);
                            await cubit.update(image);
                          },
                          child: const Text(
                            'Change photo',
                            style: TextStyle(
                                color: purpleColor,
                                fontWeight: FontWeight.w700),
                          )),
                      CustomTextField(
                          controller: cubit.nameController,
                          title: 'Name Channel',
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'Name is empty';
                            }
                            return null;
                          },
                          isPassword: false),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: cubit.aboutController,
                          title: 'About',
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'About is empty';
                            }
                            return null;
                          },
                          isPassword: false),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Resizable.width(context) * 0.8,
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Choose Topics",
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: Resizable.font(context, 20)),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            MultiSelectChipField(
                              items: items,
                              initialValue: const [],
                              showHeader: false,
                              title: const Text(
                                "Topics",
                                style: TextStyle(color: secondaryColor),
                              ),
                              scroll: false,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: primaryColor)),
                              headerColor: secondaryColor.withOpacity(0.25),
                              selectedChipColor: primaryColor,
                              selectedTextStyle:
                              const TextStyle(color: Colors.white),
                              onTap: (values) {
                                cubit.updateTopics(
                                    values.map((e) => e as Topic).toList());
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              onTap: () async {
                                final isValid =
                                cubit._formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }
                                cubit._formKey.currentState!.save();

                                if (cubit.listTopicChoose.isEmpty) {
                                  CustomToast.showBottomToast(
                                      context, 'Please choose Topic');
                                  return;
                                }
                                var url = baseImage;
                                if (cubit.image != null) {
                                  url = await CloudService.instance.uploadImage(
                                      File(cubit.image!.path),
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString());
                                }

                                var channel = ChannelModel(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    name: cubit.nameController.text,
                                    imageUrl: url,
                                    about: cubit.aboutController.text,
                                    topics: cubit.listTopicChoose.map((e) => e.id).toList(),
                                    subscribed: [],
                                    isUser: false,
                                    idUser: '',
                                    info: {});

                                var res = await ApiChannel.instance.addChannel(channel.toJson());

                                if(res != null) {
                                  await adminChannelsCubit.load();
                                  if(context.mounted) {
                                    CustomToast.showBottomToast(context, 'Create Successfully');
                                    Navigator.pop(context);

                                  }

                                }
                                else {
                                  if(context.mounted) {
                                    CustomToast.showBottomToast(context, 'Create Error');
                                  }
                                }
                              },
                              title: 'Create',
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              height: 30,
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AdCreateChannelCubit extends Cubit<int> {
  AdCreateChannelCubit() : super(0);
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  XFile? image;
  bool isCreating = false;
  final _formKey = GlobalKey<FormState>();
  List<Topic> listTopic = [];
  List<Topic> listTopicChoose = [];

  load() async {
    listTopic = await ApiTopic.instance.getListTopics();
    emit(state + 1);
  }

  update(XFile? img) {
    image = img;
    emit(state + 1);
  }

  updateCreate(bool value) {
    isCreating = value;
    emit(state + 1);
  }


  updateTopics(List<Topic> values) {
    listTopicChoose = values;
    emit(state + 1);
  }
}
