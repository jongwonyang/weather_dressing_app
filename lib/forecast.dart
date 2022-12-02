import 'package:flutter/material.dart';

class DailyForecast with ChangeNotifier{
  Map<String, Temperature> dataList = {};

  updateForecast(Map<String, Temperature> dataList) {
    this.dataList = dataList;
    notifyListeners();
  }

  @override
  String toString() {
    // TODO: implement toString
    String result = '';
    for (var key in dataList.keys!) {
      result += dataList[key].toString() + ' ';
    }
    return result;
  }
}

class Temperature {
  // 하늘상태(SKY) 코드 : 맑음(1), 구름많음(3), 흐림(4)
  // 강수형태(PTY) 코드 : 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)

  var sky = 0;
  var pty = 0;
  var tmp = 0;
  var tmn = 0;
  var tmx = 0;

  Temperature(int sky, int pty, int tmp, int tmn, int tmx) {
    this.sky = sky;
    this.pty = pty;
    this.tmp = tmp;
    this.tmn = tmn;
    this.tmx = tmx;
  }

  @override
  String toString() {
    // TODO: implement toString
    return '${this.sky} ${this.pty} ${this.tmp} ${this.tmn} ${this.tmx}';
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