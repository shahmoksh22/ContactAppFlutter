import 'package:flutter/material.dart';

class PlatformProvider extends ChangeNotifier{
  bool isandroid = true;
  void changeplatform(){
    isandroid = !isandroid;
    notifyListeners();
  }
}