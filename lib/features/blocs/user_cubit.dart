import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);


  update(UserModel? value) {
    emit(value);
  }
}
