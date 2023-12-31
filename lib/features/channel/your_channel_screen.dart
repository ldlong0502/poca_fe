import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/models/channel_model.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/screens/channel_screen.dart';
import 'package:poca/utils/convert_utils.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/widgets/custom_text_field.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../configs/constants.dart';
import '../../models/topic.dart';
import '../../services/cloud_service.dart';
import '../../utils/resizable.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/network_image_custom.dart';
import '../../screens/base_screen.dart';

class CreateYourChannelScreen extends StatelessWidget {
  const CreateYourChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
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
          create: (context) => CreateChannelCubit(userCubit.state!)..load(),
          child: BlocBuilder<CreateChannelCubit, int>(
            builder: (context, state) {
              if (state == 0) return const LoadingProgress();
              final cubit = context.read<CreateChannelCubit>();
              final items = cubit.listTopic
                  .map((e) => MultiSelectItem<Topic>(e, e.name))
                  .toList();
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
                              url: cubit.user.imageUrl,
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
                      CustomTextField(
                          controller: cubit.hobbiesController,
                          title: 'Hobbies',
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'Hobbies is empty';
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
                            Row(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Choose Sex",
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize:
                                              Resizable.font(context, 20)),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: cubit.selectedSex,
                                    hint: const Text(
                                      'Choose sex',
                                    ),
                                    iconSize: 0,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: Resizable.font(context, 20)),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 20),
                                        fillColor:
                                            secondaryColor.withOpacity(0.25),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                        )),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      cubit.updateSex(value!);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "can't empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    items: cubit.listSex.map((String val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Choose Zodiac",
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize:
                                              Resizable.font(context, 20)),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: cubit.selectedZodiac,
                                    hint: const Text(
                                      'Choose zodiac',
                                    ),
                                    iconSize: 0,
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: Resizable.font(context, 20)),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 20),
                                        fillColor:
                                            secondaryColor.withOpacity(0.25),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                        )),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      cubit.updateZodiac(value!);
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "can't empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    items: cubit.zodiacSigns.map((String val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
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
                                var url = cubit.user.imageUrl;
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
                                    isUser: true,
                                    idUser: cubit.user.id,
                                    info: {
                                      'zodiac': cubit.selectedZodiac,
                                      'sex': cubit.selectedSex,
                                      'dob': ConvertUtils.convertDob(cubit.user.dateOfBirth),
                                      'hobbies': cubit.hobbiesController.text
                                    });

                                var res = await ApiChannel.instance.addChannel(channel.toJson());

                                if(res != null) {
                                  if(context.mounted) {
                                    CustomToast.showBottomToast(context, 'Create Successfully');
                                    Navigator.pop(context);
                                    NavigatorCustom.pushNewScreen(context, ChannelScreen(channel: res), AppRoutes.channel);

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

class CreateChannelCubit extends Cubit<int> {
  CreateChannelCubit(this.user) : super(0);
  final UserModel user;
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final hobbiesController = TextEditingController();
  XFile? image;
  bool isCreating = false;
  final _formKey = GlobalKey<FormState>();
  List<Topic> listTopic = [];
  List<Topic> listTopicChoose = [];
  List<String> listSex = ['Female', 'Male', 'Other'];
  String selectedSex = 'Female';
  String selectedZodiac = 'Aries';
  List<String> zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

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

  updateSex(String value) {
    selectedSex = value;
    emit(state + 1);
  }

  updateZodiac(String value) {
    selectedZodiac = value;
    emit(state + 1);
  }

  updateTopics(List<Topic> values) {
    listTopicChoose = values;
    emit(state + 1);
  }
}
