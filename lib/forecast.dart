import 'package:flutter/material.dart';

class DailyForecast with ChangeNotifier{
  Map<String, Temperature> dataList = {};

  updateForecast(Map<String, Temperature> dataList) {
    this.dataList = dataList;
    notifyListeners();
  }
}

class Temperature {
  var tmp = 0;
  var tmn = 0;
  var tmx = 0;

  Temperature(int tmp, int tmn, int tmx) {
    this.tmp = tmp;
    this.tmn = tmn;
    this.tmx = tmx;
  }
}

class Forecast {
  var baseDate = '';
  var baseTime = '';
  var category = '';
  var fcstDate = '';
  var fcstTime = '';
  var fcstValue = '';
  var nx = 0;
  var ny = 0;

  Forecast.fromJson(Map<String, dynamic> json)
      : baseDate = json['baseDate'],
        baseTime = json['baseTime'],
        category = json['category'],
        fcstDate = json['fcstDate'],
        fcstTime = json['fcstTime'],
        fcstValue = json['fcstValue'],
        nx = json['nx'],
        ny = json['ny'];

}