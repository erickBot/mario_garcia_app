import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/control_peso.dart';
import 'package:flutter_mario_garcia_app/models/register_planta.dart';

class DataProvider extends ChangeNotifier {
  int _plantaCount = 0;
  int _muelleCount = 0;
  List<RegisterPlanta> _plantaList = [];
  List<ControlPeso> _muelleList = [];

  int get currentPlantaCount => _plantaCount;
  int get currentMuelleCount => _muelleCount;
  List<RegisterPlanta> get currentPlantaList => _plantaList;
  List<ControlPeso> get currentMuelleList => _muelleList;

  void setCurrentData(int plantaCount, int muelleCount,
      List<RegisterPlanta> plantaList, List<ControlPeso> muelleList) {
    _plantaCount = plantaCount;
    _muelleCount = muelleCount;
    _plantaList = plantaList;
    _muelleList = muelleList;
    notifyListeners();
  }
}
