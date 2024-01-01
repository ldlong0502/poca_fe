import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poca/features/account/edit_account.dart';
import 'package:poca/features/account/none_account_view.dart';
import 'package:poca/features/blocs/user_cubit.dart';
import 'package:poca/features/dialogs/normal_dialog.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/providers/api/api_channel.dart';
import 'package:poca/providers/preference_provider.dart';
import 'package:poca/routes/app_routes.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/screens/change_pass_screen.dart';
import 'package:poca/screens/channel_screen.dart';
import 'package:poca/screens/library_screen.dart';
import 'package:poca/screens/playlist_screen.dart';
import 'package:poca/features/channel/your_channel_screen.dart';
import 'package:poca/utils/dialogs.dart';
import 'package:poca/utils/helper_utils.dart';
import 'package:poca/utils/navigator_custom.dart';
import 'package:poca/utils/resizable.dart';
import 'package:poca/widgets/custom_button.dart';

import '../configs/constants.dart';
import '../providers/api/api_auth.dart';
import '../services/nfc_services.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    var mapItems = [
      {
        'title': 'Account',
        'showIcon': false,
        'onClick': () {
          Dialogs.showBottomSheet(context, const EditAccount());
        },
      },
      {
        'title': 'Save info to NFC',
        'showIcon': false,
        'onClick': () async {
          var username = await PreferenceProvider.instance.getString('username');
          var password = await PreferenceProvider.instance.getString('password');
          var key = HelperUtils().encrypt('$username:$password');
         if(context.mounted){
           Dialogs.showNFCAction(context , 'Write');
           NFCServices.instance.writeToNFC( 0, key, context);
         }
        },
      },
      {
        'title': 'Your library',
        'showIcon': true,
        'onClick': () {
          NavigatorCustom.pushNewScreen(
              context, const YourLibrary(), '/library');
        },
      },
      {
        'title': 'Playlist',
        'showIcon': true,
        'onClick': () {
          print('++++++++ click');
          NavigatorCustom.pushNewScreen(
              context, const PlaylistScreen(), AppRoutes.playlist);
        },
      },
      {
        'title': 'Your Channel',
        'showIcon': true,
        'onClick': () async {
          final user = context.read<UserCubit>();
          final channel =
              await ApiChannel.instance.getChannelByUser(user.state!.id);
          if (channel == null) {
            if (context.mounted) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NormalDialog(
                        onYes: () {
                          if(context.mounted) {
                            Navigator.pop(context);
                            NavigatorCustom.pushNewScreen(context, const CreateYourChannelScreen(), '/yourChannel');
                          }
                        },
                        onCancel: (){
                          Navigator.pop(context);
                        },
                        title: 'Don\'t have any Channels?',
                        content: 'Do you want to create new channel?');
                  });
            }

          }
          else {
            if(context.mounted) {
              NavigatorCustom.pushNewScreen(context,  ChannelScreen(channel: channel!), AppRoutes.channel);
            }
          }
        },
      },
      {
        'title': 'Private & Social',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Terms & Conditions',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Change Password',
        'showIcon': true,
        'onClick': () {
          NavigatorCustom.pushNewScreen(
              context, const ChangePasswordScreen(), '/changePass');
        },
      },
      {
        'title': 'About',
        'showIcon': true,
        'onClick': () {},
      },
    ];
    return BaseScreen(
      title: 'Account',
      child: SingleChildScrollView(
        child: BlocBuilder<UserCubit, UserModel?>(
          builder: (context, state) {
            if (state == null) return const NoneAccountView();
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      ...mapItems.map((e) {
                        return GestureDetector(
                          onTap: e['onClick'] as Function(),
                          child: SizedBox(
                            height: Resizable.size(context, 50),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  e['title'] as String,
                                  style: TextStyle(
                                      fontSize: Resizable.font(context, 20),
                                      color: textColor,
                                      fontWeight: FontWeight.w600),
                                )),
                                SizedBox(
                                  width: Resizable.size(context, 50),
                                  child: !(e['showIcon'] as bool)
                                      ? null
                                      : const IconButton(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: secondaryColor,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          title: 'Log out',
                          onTap: () {
                            ApiAuthentication.instance.logOut(context);
                          },
                          backgroundColor: primaryColor,
                          textColor: Colors.white),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
