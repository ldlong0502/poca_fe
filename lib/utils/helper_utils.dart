import 'package:poca/models/user_model.dart';

import '../providers/preference_provider.dart';

class HelperUtils {

  static Future<UserModel?> checkLogin()  async {
    var user = await PreferenceProvider.instance.getJsonFromPrefs("user");
    if(user != null) return UserModel.fromJson(user);
    return null;
  }
}