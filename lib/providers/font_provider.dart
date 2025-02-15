import 'package:flutter/material.dart';

import '../services/prefs.dart';

class ReaderFontProvider extends ChangeNotifier {
  late int _fontSize;
  int get fontSize => _fontSize;

  ReaderFontProvider() {
    _init();
  }

  void _init() {
    _fontSize = Prefs.readerFontSize;
  }

  void onIncreaseFontSize() {
    _fontSize += 1;
    Prefs.readerFontSize = _fontSize;
    notifyListeners();
  }

  void onDecreaseFontSize() {
    _fontSize -= 1;
    Prefs.readerFontSize = _fontSize;
    notifyListeners();
  }
}

