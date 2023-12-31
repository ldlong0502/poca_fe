import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/channel/about_channel.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/custom_text_field.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../models/topic.dart';
import '../../providers/api/api_topic.dart';
import '../../services/cloud_service.dart';
import '../../utils/custom_toast.dart';
import '../../utils/resizable.dart';
import '../../widgets/network_image_custom.dart';
import '../blocs/channel_detail_cubit.dart';

class EditPodcastView extends StatelessWidget {
  const EditPodcastView({super.key, required this.listPodcastCubit, required this.podcast});
  final Podcast podcast;
  final ListPodcastCubit listPodcastCubit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: primaryColor),
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
                    create: (context) => EditPodcastCubit(podcast, listPodcastCubit)..load(),
                    child: BlocBuilder<EditPodcastCubit, int>(
                      builder: (context, state) {
                        if (state == 0) {
                          return const Center(
                            child: LoadingProgress(),
                          );
                        }
                        final cubit = context.read<EditPodcastCubit>();
                        final items = cubit.listTopic
                            .map((e) =>
                            MultiSelectItem<Topic>(e, e.name))
                            .toList();
                        var baseImage = cubit.podcast.imageUrl;
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
                                      initialValue: cubit.listTopicChoose.map((e) => e as dynamic).toList(),
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

                                  var p = Podcast(id: '',
                                      title: cubit.titleController.text, description:
                                      cubit.desController.text,
                                      topicsList: cubit.listTopicChoose,
                                      host: cubit.podcast.host,
                                      episodesList: cubit.podcast.episodesList,
                                      publishDate: cubit.podcast.publishDate,
                                      subscribesList: cubit.podcast.subscribesList,
                                      favoritesList: cubit.podcast.favoritesList,
                                      imageUrl: url);

                                  if(jsonEncode(p.toJson() ) == jsonEncode(cubit.podcast.toJson())) {
                                    if(context.mounted){
                                      CustomToast.showBottomToast(context, 'Nothing change');
                                      return;
                                    }
                                  }
                                  var res = await ApiPodcast.instance.updatePodcast(podcast.id , p.toJsonNoId());

                                  if(res != null) {
                                    await cubit.listPodcastCubit.load();
                                    if(context.mounted) {
                                      CustomToast.showBottomToast(context, 'Update Successfully');
                                      Navigator.pop(context);

                                    }

                                  }
                                  else {
                                    if(context.mounted) {
                                      CustomToast.showBottomToast(context, 'Update Error');
                                    }
                                  }
                                },
                                title: 'Update',
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

class EditPodcastCubit extends Cubit<int> {
  EditPodcastCubit(this.podcast, this.listPodcastCubit) : super(0);
  final Podcast podcast;
  final ListPodcastCubit listPodcastCubit;
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var desController = TextEditingController();
  List<Topic> listTopic = [];
  List<Topic> listTopicChoose = [];
  XFile? image;

  update(XFile? img) {
    image = img;
    emit(state + 1);
  }

  load() async {
    titleController = TextEditingController(text: podcast.title);
    desController = TextEditingController(text: podcast.description);
    listTopic = await ApiTopic.instance.getListTopics();
    listTopicChoose = listTopic.where((element) => podcast.topicsList.map((e) => e.id).contains(element.id)).toList();

    print('=>>>>${podcast.topicsList}');
    emit(state + 1);
  }

  updateTopics(List<Topic> values) {
    listTopicChoose = values;
    emit(state + 1);
  }
}
