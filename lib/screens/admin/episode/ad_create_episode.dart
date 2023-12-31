import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/models/episode.dart';
import 'package:poca/models/podcast.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/screens/admin/admin_episodes.dart';
import 'package:poca/services/sound_service.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/custom_text_field.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../../services/cloud_service.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/network_image_custom.dart';



class AdCreateEpisodeView extends StatelessWidget {
  const AdCreateEpisodeView({super.key, required this.adminEpisodesCubit});

  final AdminEpisodesCubit adminEpisodesCubit;

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
                    create: (context) =>
                    AdCreateEpisodeCubit()
                      ..load(),
                    child: BlocBuilder<AdCreateEpisodeCubit, int>(
                      builder: (context, state) {
                        if (state == 0) {
                          return const Center(
                            child: LoadingProgress(),
                          );
                        }
                        final cubit = context.read<AdCreateEpisodeCubit>();
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
                                      'Podcast',
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
                                    child: DropdownButtonFormField<Podcast>(
                                      value: cubit.selectPodcast,
                                      hint: const Text(
                                        'Choose podcast',
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
                                        cubit.updateChoosePodcast(value!);
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Podcast can't empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                      items: cubit.listPodcast.map((val) {
                                        return DropdownMenuItem(
                                          value: val,
                                          child: Text(
                                            val.title,
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
                                      'Audio',
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
                                    child: InkWell(
                                      onTap: () async {
                                        FilePickerResult? result = await FilePicker
                                            .platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['mp3'],
                                        );

                                        cubit.updateFilePicker(result);
                                      },
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            color: secondaryColor.withOpacity(
                                                0.25)
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Text('${cubit.result == null
                                                ? 'Choose File'
                                                : cubit.result?.files.first
                                                .name}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,

                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Resizable.font(
                                                      context, 20)
                                              ),),
                                          ),
                                        ),
                                      ),
                                    ),

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
                                      'Duration',
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
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: secondaryColor.withOpacity(
                                              0.25)
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Text('${cubit.duration ?? ''}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,

                                            style: TextStyle(
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Resizable.font(
                                                    context, 20)
                                            ),),
                                        ),
                                      ),
                                    ),

                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                onTap: () async {
                                  if (cubit.isCreating) {
                                    CustomToast.showBottomToast(
                                        context, 'Wait for updating');
                                    return;
                                  }
                                  final isValid =
                                  cubit._formKey.currentState!.validate();
                                  if (!isValid) {
                                    return;
                                  }
                                  cubit._formKey.currentState!.save();
                                  cubit.updateCreate(true);
                                  if (cubit.result == null) {
                                    CustomToast.showBottomToast(
                                        context, 'Please choose audio');
                                    return;
                                  }
                                  var url = baseImage;
                                  if (cubit.image != null) {
                                    url =
                                    await CloudService.instance.uploadImage(
                                        File(cubit.image!.path),
                                        DateTime
                                            .now()
                                            .millisecondsSinceEpoch
                                            .toString());
                                  }

                                  var audioFile = await CloudService.instance
                                      .uploadMp3(
                                      File(cubit.result!.files.first.path!),
                                      DateTime
                                          .now()
                                          .millisecondsSinceEpoch
                                          .toString());
                                  var episode = Episode(id: '',
                                      title: cubit.titleController.text,
                                      description: '',
                                      duration: cubit.duration!,
                                      audioFile: audioFile,
                                      publishDate: DateTime.now().millisecondsSinceEpoch,
                                      listens: 0,
                                      imageUrl: url,
                                      favoritesList: []);

                                  var res = await ApiEpisode.instance.createEpisode(cubit.selectPodcast!.id, episode.toJson());
                                  if(res != null) {
                                    await adminEpisodesCubit.load();
                                    if(context.mounted) {
                                      cubit.updateCreate(false);
                                      CustomToast.showBottomToast(context, 'Create Successfully');
                                      Navigator.pop(context);


                                    }

                                  }
                                  else {
                                    if(context.mounted) {
                                      cubit.updateCreate(false);
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
                                height: 20,
                              ),
                              if (cubit.isCreating)
                                const LoadingProgress(
                                  color: primaryColor,
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

class AdCreateEpisodeCubit extends Cubit<int> {
  AdCreateEpisodeCubit() : super(0);
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  int? duration;
  List<Podcast> listPodcast = [];
  XFile? image;
  FilePickerResult? result;
  Podcast? selectPodcast;
  bool isCreating = false;
  updateCreate(bool value) {
    isCreating = value;
    emit(state + 1);
  }
  update(XFile? img) {
    image = img;
    emit(state + 1);
  }

  updateFilePicker(FilePickerResult? img) async {
    result = img;
    duration =
        (await AudioPlayer().setFilePath(result!.files.first.path!))?.inSeconds;
    print(duration);
    emit(state + 1);
  }

  load() async {
    listPodcast = await ApiPodcast.instance.getAllPodcasts();
    emit(state + 1);
  }

  updateChoosePodcast(Podcast value) {
    selectPodcast = value;
    emit(state + 1);
  }
}
