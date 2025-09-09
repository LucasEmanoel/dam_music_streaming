import 'package:flutter/material.dart';

class PlayerScreenViewModel extends ChangeNotifier {
  int _indexStack = 0;

  int get indexStack => _indexStack;

  void setStackIndex(int index) {
    _indexStack = index;
    notifyListeners();
  }
}
