import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/screens/admin/admin_podcasts.dart';

import '../../../configs/constants.dart';
import '../../../models/channel_model.dart';
import '../../../models/podcast.dart';
import '../../../models/topic.dart';
import '../../../providers/api/api_podcast.dart';
import '../../../providers/api/api_topic.dart';
import '../../../services/cloud_service.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_progress.dart';
import '../../../widgets/network_image_custom.dart';

class AdCreatePodcastView extends StatelessWidget {
  const AdCreatePodcastView({super.key, required this.adminPodcastsCubit});
  final AdminPodcastsCubit adminPodcastsCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: SizedBox(
        height: Resizable.height(context),
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: primaryColor,
                  icon: Icon(Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocProvider(
                    create: (context) => AdCreatePodcastCubit()..load(),
                    child: BlocBuilder<AdCreatePodcastCubit, int>(
                      builder: (context, state) {
                        if (state == 0) {
                          return const Center(
                            child: LoadingProgress(),
                          );
                        }
                        final cubit = context.read<AdCreatePodcastCubit>();
                        final items = cubit.listTopic
                            .map((e) =>
                            MultiSelectItem<Topic>(e, e.name))
                            .toList();
                        var baseImage = 'https://th.bing.com/th/id/R.5b90b8a4c8fbbfde71b88e5caa6abd09?rik=YpZ0j5CZOgV7UQ&pid=ImgRaw&r=0';
                        return Form(
                          key: cubit._formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    borderRadius:
                                    BorderRadius.circular(1000)),
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
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Channel',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: Resizable.font(context, 20),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: DropdownButtonFormField<ChannelModel>(
                                      value: cubit.selectChannel,
                                      hint: const Text(
                                        'Choose channel',
                                      ),
                                      iconSize: 0,
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: Resizable.font(
                                              context, 20)),
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
                                        cubit.updateSelectChannel(value!);
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Channel can't empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      items: cubit.listChannel.map((val) {
                                        return DropdownMenuItem(
                                          value: val,
                                          child: Text(
                                            val.name,
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
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Title',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: Resizable.font(context, 20),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomTextField(
                                        controller: cubit.titleController,
                                        title: '',
                                        onValidate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Title is empty';
                                          }
                                          return null;
                                        },
                                        isPassword: false),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Description',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: Resizable.font(context, 20),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CustomTextField(
                                        controller: cubit.desController,
                                        title: '',
                                        onValidate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Description is empty';
                                          }
                                          return null;
                                        },
                                        isPassword: false),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment:Alignment.centerLeft,
                                child: Text(
                                  'Topics',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: Resizable.font(context, 20),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: MultiSelectChipField(
                                      items: items,
                                      initialValue: const [],
                                      showHeader: false,
                                      scroll: false,
                                      title: const Text(
                                        "Topics",
                                        style: TextStyle(color: secondaryColor),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border:
                                          Border.all(color: primaryColor)),
                                      headerColor:
                                      secondaryColor.withOpacity(0.25),
                                      selectedChipColor: primaryColor,
                                      selectedTextStyle:
                                      const TextStyle(color: Colors.white),
                                      onTap: (values) {
                                        cubit.updateTopics(values
                                            .map((e) => e as Topic)
                                            .toList());
                                      },
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
                                  var url = baseImage;
                                  if (cubit.image != null) {
                                    url = await CloudService.instance.uploadImage(
                                        File(cubit.image!.path),
                                        DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString());
                                  }

                                  var podcast = Podcast(id: '',
                                      title: cubit.titleController.text, description:
                                      cubit.desController.text,
                                      topicsList: cubit.listTopicChoose,
                                      host: cubit.selectChannel!.id,
                                      episodesList: [],
                                      publishDate: DateTime.now().millisecondsSinceEpoch,
                                      subscribesList: [],
                                      favoritesList: [],
                                      imageUrl: url);
                                  var res = await ApiPodcast.instance.createPodcast(podcast.toJson());

                                  if(res != null) {
                                    await adminPodcastsCubit.load();
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
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AdCreatePodcastCubit extends Cubit<int> {
  AdCreatePodcastCubit() : super(0);
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var desController = TextEditingController();
  List<Topic> listTopic = [];
  List<ChannelModel> listChannel = [];
  List<Topic> listTopicChoose = [];
  XFile? image;
  ChannelModel? selectChannel;
  update(XFile? img) {
    image = img;
    emit(state + 1);
  }
  updateSelectChannel(ChannelModel? value){
    selectChannel = value;
    emit(state+1);
  }
  load() async {
    listTopic = await ApiTopic.instance.getListTopics();
    listChannel = await ApiChannel.instance.getAllChannels();
    emit(state + 1);
  }

  updateTopics(List<Topic> values) {
    listTopicChoose = values;
    emit(state + 1);
  }
}
