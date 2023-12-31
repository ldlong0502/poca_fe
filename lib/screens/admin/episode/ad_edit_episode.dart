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



class AdEditEpisodeView extends StatelessWidget {
  const AdEditEpisodeView({super.key, required this.adminEpisodesCubit, required this.episode});

  final AdminEpisodesCubit adminEpisodesCubit;
  final Episode episode;
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
                    AdEditEpisodeCubit(episode)
                      ..load(),
                    child: BlocBuilder<AdEditEpisodeCubit, int>(
                      builder: (context, state) {
                        if (state == 0) {
                          return const Center(
                            child: LoadingProgress(),
                          );
                        }
                        final cubit = context.read<AdEditEpisodeCubit>();
                        var baseImage = episode.imageUrl;
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
                                                ? episode.audioFile
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
                                  var url = baseImage;
                                  if (cubit.image != null) {
                                    url =
                                    await CloudService.instance.uploadImage(
                                        File(cubit.image!.path),
                                        DateTime
                                            .now()
                                            . millisecondsSinceEpoch
                                            .toString());
                                  }
                                  var audioFile = episode.audioFile;
                                  if(cubit.result != null) {
                                    audioFile = await CloudService.instance
                                        .uploadMp3(
                                        File(cubit.result!.files.first.path!),
                                        DateTime
                                            .now()
                                            .millisecondsSinceEpoch
                                            .toString());
                                  }
                                  var e = Episode(id: '',
                                      title: cubit.titleController.text,
                                      description: episode.description,
                                      duration: cubit.duration!,
                                      audioFile: audioFile,
                                      publishDate: DateTime.now().millisecondsSinceEpoch,
                                      listens: episode.listens,
                                      imageUrl: url,
                                      favoritesList: episode.favoritesList);

                                  var res = await ApiEpisode.instance.updateEpisode(episode.id, e.toJson());
                                  if(res) {
                                    await adminEpisodesCubit.load();
                                    if(context.mounted) {
                                      cubit.updateCreate(false);
                                      CustomToast.showBottomToast(context, 'Update Successfully');
                                      Navigator.pop(context);


                                    }

                                  }
                                  else {
                                    if(context.mounted) {
                                      cubit.updateCreate(false);
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

class AdEditEpisodeCubit extends Cubit<int> {
  AdEditEpisodeCubit(this.episode) : super(0);
  final Episode episode;
  final _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  int? duration;
  XFile? image;
  FilePickerResult? result;
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
    titleController = TextEditingController(text: episode.title);
    duration = episode.duration;
    emit(state + 1);
  }
}
