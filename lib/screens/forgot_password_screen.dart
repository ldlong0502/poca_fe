import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/dialogs/login_dialog.dart';
import 'package:poca/providers/api/api_auth.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/utils/custom_toast.dart';
import 'package:poca/utils/helper_utils.dart';
import 'package:poca/widgets/loading_progress.dart';

import '../utils/resizable.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  String hideEmail(String string, {int consoreLevel = 2}) {
    final parts = string.split("@");

    if (parts.length != 2) {
      // Handle the case where there is no "@" separator in the string
      return string;
    }

    final stringBeforeA = parts[0];
    final stringAfterA = parts[1];

    final unconsoredBeforeA = stringBeforeA.replaceRange(
        consoreLevel, stringBeforeA.length - consoreLevel, "*" * (stringBeforeA.length - consoreLevel * 2));

    return "$unconsoredBeforeA@$stringAfterA";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text(
          'Trouble signing in?',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => ForgotPassCubit(),
          child: BlocBuilder<ForgotPassCubit, int>(
            builder: (context, state) {
              final cubit = context.read<ForgotPassCubit>();
              return Form(
                key: cubit._formKey,
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(  'assets/icons/ic_${cubit.status == SendStatus.sent ? 'mail_sent': 'trouble'}.png' , scale: 2, height: 120,),
                            cubit.status == SendStatus.sent ?  Column(
                              children: [
                                const Text('A link for reset password has already sent to email: ',  textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: secondaryColor
                                    )),
                                Text(hideEmail(cubit.message) ,  textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: textColor
                                    )),
                              ],
                            ): const Text(
                                "Enter your username or email and \nwe’ll send you a link to get back into \nyour account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryColor
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    if(cubit.status != SendStatus.sent)
                    CustomTextField(
                        controller: cubit.usernameController,
                        title: 'Username',
                        onValidate: (String value) {
                          if (value.isEmpty) {
                            return 'Username is empty';
                          }
                          return null;
                        },
                        isPassword: false),
                    const SizedBox(
                      height: 30,
                    ),
                    if(cubit.status != SendStatus.sent)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                          title: cubit.status == SendStatus.sending ? 'Sending...': 'Send sign link',
                          onTap: () async {
                            if(cubit.status == SendStatus.sending){
                              return;
                            }
                            final isValid =
                            cubit._formKey.currentState!.validate();
                            if (!isValid) {
                              return;
                            }
                            cubit._formKey.currentState!.save();
                            cubit.updateSending(SendStatus.sending);
                            var res = await ApiAuthentication.instance.resetPass(cubit.usernameController.text);

                            if(res == null) {
                              cubit.updateSending(SendStatus.normal);
                             if(context.mounted){
                               showDialog<void>(
                                 context: context,
                                 builder: (BuildContext dialogContext) {
                                   return const ErrorDialog(title: 'Error', content: 'Not exist user');
                                 },
                               );

                             }
                             return;
                            }
                            else {
                              cubit.updateMessage(res);
                              cubit.updateSending(SendStatus.sent);
                            }
                          },
                          width: Resizable.width(context) * 0.8,
                          backgroundColor: primaryColor,
                          textColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if(cubit.status == SendStatus.sending)
                      const LoadingProgress()
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum SendStatus {
  normal, sending, sent
}
class ForgotPassCubit extends Cubit<int> {
  ForgotPassCubit() : super(0);
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  SendStatus status = SendStatus.normal;

  updateSending(SendStatus value) {
    status = value;
    emit(state + 1);
  }

  String message = 'A link';

  updateMessage(String value) {
    message = value;
    emit(state + 1);
  }

}
