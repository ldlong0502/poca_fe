import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/features/blocs/password_cubit.dart';

import '../utils/resizable.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.title,
      required this.onValidate,
      required this.isPassword});

  final TextEditingController controller;
  final String title;
  final Function onValidate;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordCubit(),
      child: BlocBuilder<PasswordCubit, bool>(
        builder: (context, state) {
          final cubit = context.read<PasswordCubit>();
          return TextFormField(
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              obscureText: isPassword ? !state : false,
              validator: (value) {
               return    onValidate(value);
              },
              style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)
                ),
                fillColor: secondaryColor.withOpacity(0.25),
                filled: true,
                hintText: title,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Resizable.font(context, 20),
                    color: secondaryColor),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Resizable.padding(context, 20),
                  vertical: Resizable.padding(context, 20),
                ),
                constraints: BoxConstraints(
                  maxWidth: Resizable.width(context) * 0.8,
                ),
                suffixIcon: IconButton(
                  onPressed: cubit.update,
                  icon: isPassword
                      ? Icon(
                      !state
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: secondaryColor)
                      : Container(),
                ),
              ));
        },
      ),
    );
  }
}
