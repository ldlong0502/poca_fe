import 'package:flutter/material.dart';
import 'package:poca/screens/base_screen.dart';
import 'package:poca/utils/resizable.dart';

import '../configs/constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.isLogin});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    var mapItems = [
      {
        'title': 'Account',
        'showIcon': false,
        'onClick': () {},
      },
      {
        'title': 'Your library',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Languages',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Playback',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Audio Quality',
        'showIcon': true,
        'onClick': () {},
      },
      {
        'title': 'Storage',
        'showIcon': true,
        'onClick': () {},
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
        'onClick': () {},
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
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  ...mapItems.map((e) {
                    return Container(
                      height: Resizable.size(context, 45),
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
                                : IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: secondaryColor,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    );
                  }).toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
