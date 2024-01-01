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



class CreateUserView extends StatelessWidget {
  const CreateUserView({super.key, required this.adminUsersCubit});

  final AdminUsersCubit adminUsersCubit;

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
                    CreateUserCubit()
                      ..load(),
                    child: BlocBuilder<CreateUserCubit, int>(
                      builder: (context, state) {
                        if (state == 0) {
                          return const Center(
                            child: LoadingProgress(),
                          );
                        }
                        final cubit = context.read<CreateUserCubit>();
                        var baseImage = 'https://cdn-icons-png.flaticon.com/512/1830/1830846.png';
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
                                      'Username',
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
                                        controller: cubit.userNameController,
                                        title: '',
                                        onValidate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Username is empty';
                                          }
                                          if(adminUsersCubit.listBase.map((e) => e.username).contains(value)) {
                                            return 'Username exist';
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
                                      'Email',
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
                                        controller: cubit.emailController,
                                        title: '',
                                        onValidate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Email is empty';
                                          }
                                          if(adminUsersCubit.listBase.map((e) => e.email).contains(value)) {
                                            return 'Email exist';
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
                                      'Full name',
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
                                        controller: cubit.fullNameController,
                                        title: '',
                                        onValidate: (String value) {
                                          if (value.isEmpty) {
                                            return 'Full name is empty';
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
                                      'Date of Birth',
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
                                    child:  DateFormFieldCustom(
                                      controller: cubit.dobController,
                                      title: '',
                                      onValidate: (String value) {
                                        if(value.isEmpty) {
                                          return 'Dob is empty';
                                        }
                                        return null;
                                      },
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
                                      'Password',
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
                                        controller: cubit.passWordController,
                                        title: '',
                                        onValidate: (String value) {
                                          if(value.isEmpty) {
                                            return 'Password is empty';
                                          }
                                          return null;
                                        },
                                        isPassword: true),
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

                                  var res = await ApiAuthentication.instance.signUp(
                                      cubit.emailController.text,
                                      cubit.fullNameController.text,
                                      cubit.userNameController.text,
                                      cubit.dobController.text,
                                      cubit.passWordController.text
                                  );
                                  if(res) {
                                    await adminUsersCubit.load();
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

class CreateUserCubit extends Cubit<int> {
  CreateUserCubit() : super(0);
  final _formKey = GlobalKey<FormState>();
  var userNameController = TextEditingController();
  var passWordController = TextEditingController();
  var emailController = TextEditingController();
  var fullNameController = TextEditingController();
  var dobController = TextEditingController(text: ConvertUtils.convertDob(DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day)));
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
