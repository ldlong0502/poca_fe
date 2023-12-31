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
import 'package:poca/models/topic.dart';
import 'package:poca/providers/api/api_espisode.dart';
import 'package:poca/providers/api/api_podcast.dart';
import 'package:poca/providers/api/api_topic.dart';
import 'package:poca/screens/admin/admin_topics.dart';
import 'package:poca/screens/admin/admin_users.dart';
import 'package:poca/services/sound_service.dart';
import 'package:poca/widgets/custom_button.dart';
import 'package:poca/widgets/custom_text_field.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../../../providers/api/api_auth.dart';
import '../../../services/cloud_service.dart';
import '../../../utils/convert_utils.dart';
import '../../../utils/custom_toast.dart';
import '../../../utils/resizable.dart';
import '../../../widgets/date_form_filed_custom.dart';
import '../../../widgets/network_image_custom.dart';



class CreateTopicView extends StatelessWidget {
  const CreateTopicView({super.key, required this.adminTopicsCubit});

  final AdminTopicsCubit adminTopicsCubit;
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
                    CreateTopicCubit()
                      ..load(),
                    child: BlocBuilder<CreateTopicCubit, int>(
                      builder: (context, state) {
                        if (state == 0) {
                          return const Center(
                            child: LoadingProgress(),
                          );
                        }
                        final cubit = context.read<CreateTopicCubit>();
                        var baseImage = 'https://th.bing.com/th/id/R.a9cbe6cf687a77e9c94b4b8abc171d5d?rik=RE%2bmAuiL%2bbn0Bw&pid=ImgRaw&r=0';
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
                                      'Name',
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
                                        controller: cubit.nameController,
                                        title: '',
                                        onValidate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Name is empty';
                                          }
                                          if(adminTopicsCubit.listBase.map((e) => e.name).contains(value)) {
                                            return 'Name exist';
                                          }
                                          return null;
                                        },
                                        isPassword: false),
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
                                            .millisecondsSinceEpoch
                                            .toString());
                                  }
                                  var topic = Topic(id: '', name: cubit.nameController.text, description: '', imageUrl: url, v: 0);
                                  var res = await ApiTopic.instance.createTopic(topic.toJson());
                                  if(res) {
                                    await adminTopicsCubit.load();
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

class CreateTopicCubit extends Cubit<int> {
  CreateTopicCubit() : super(0);
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
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
  load() async {
    emit(state + 1);
  }

}
