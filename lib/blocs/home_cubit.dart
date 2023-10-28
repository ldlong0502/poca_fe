import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_wave/configs/constants.dart';
import 'package:uni_wave/models/audio_book.dart';
import 'package:uni_wave/providers/firebase_provider.dart';

import '../models/ebook.dart';

class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0) {
    load();
  }

  final ScrollController scrollController = ScrollController();
  List<Ebook> top10Ebooks = [];
  List<AudioBook> top5Audiobooks = [];
  Color appBarColor = Colors.transparent;
  String defaultImage = 'https://wallpaperaccess.com/full/1155122.jpg';
  int indexEbook = 0;

  bool isScrollBackground = false;
  void load() async {
    try {
      top5Audiobooks = await FireBaseProvider.instance.getTop5AudiobooksByView();
      top5Audiobooks.shuffle();
    }
    catch (e) {
      top5Audiobooks = [];
    }
    if(isClosed) return;
    emit(state+1);
  }

  changeIndexEbook(int value) {
    indexEbook = value;
    emit(state+1);
  }

  changeAppBarColor(bool value) {
    appBarColor =  value ? purpleColor.withOpacity(0.9) : Colors.transparent;
    emit(state+1);
  }
  scrollBackground(bool value) {
    isScrollBackground = value;
    emit(state+1);
  }
}
