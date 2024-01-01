import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/dialogs/login_dialog.dart';
import 'package:poca/providers/api/api_auth.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/utils/helper_utils.dart';

import '../utils/resizable.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text(
          'Change Password',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => ChangePassCubit(),
        child: BlocBuilder<ChangePassCubit, int>(
          builder: (context, state) {
            final cubit = context.read<ChangePassCubit>();
            return SingleChildScrollView(
              child: Form(
                key: cubit._formKey,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                          controller: cubit.currentPassController,
                          title: 'Current Password',
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'Current Password is empty';
                            }
                            return null;
                          },
                          isPassword: true),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                          controller: cubit.newPassController,
                          title: 'New Password',
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'New Password is empty';
                            }
                            if (value.length <6) {
                              return 'New Password is greater than 6 characters';
                            }
                            return null;
                          },
                          isPassword: true),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                          controller: cubit.againPassController,
                          title: 'Retype Again Password',
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'Again Password is empty';
                            }
                            if (value != cubit.newPassController.text) {
                              return 'Incorrect again password';
                            }
                            return null;
                          },
                          isPassword: true),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            title: 'Change Password',
                            onTap: () async {
                              final isValid =
                                  cubit._formKey.currentState!.validate();
                              if (!isValid) {
                                return;
                              }
                              cubit._formKey.currentState!.save();

                              var password = await PreferenceProvider.instance.getString('password');
                              if(cubit.currentPassController.text != password) {
                                if(context.mounted) {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return const ErrorDialog(title: 'Error', content: 'Invalid current password');
                                    },
                                  );
                                }
                                return;
                              }
                              var user = await HelperUtils.checkLogin();
                              var res = await  ApiAuthentication.instance.changePass(user!.id, cubit.newPassController.text);
                              if(res) {
                                if(context.mounted) {
                                  CustomToast.showBottomToast(context, 'Password changed');
                                  Navigator.pop(context);
                                }
                              } else {

                              }
                            },
                            width: Resizable.width(context) * 0.8,
                            backgroundColor: primaryColor,
                            textColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChangePassCubit extends Cubit<int> {
  ChangePassCubit() : super(0);

  final _formKey = GlobalKey<FormState>();
  var currentPassController = TextEditingController();
  var newPassController = TextEditingController();
  var againPassController = TextEditingController();
}
