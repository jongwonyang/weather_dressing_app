import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http_pk;
import 'dart:convert';
import 'calculate.dart';
import 'forecast.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void getWeather() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var latitude = position.latitude;
    var longitude = position.longitude;

    WeatherMapXY weathermapxy = changelaluMap(longitude, latitude);
    var nx = weathermapxy.x.toString();
    var ny = weathermapxy.y.toString();

    String numOfRows = '12';
    var dateTime = DateTime.now().toString().split(' ');
    String base_date = getBaseDate(dateTime[0]);
    String base_time = getBaseTime(dateTime[1]);

    const ServiceKey = '7o4wY20Oec3aLc6GSWaZYqOl%2BWM%2Bd9I0TOkWUM15tF3qShnUAmVFV%2BM%2BTWkn9g8TocHyzYjDpU5o7iaOLEKVsA%3D%3D';
    http_pk.Response response = await http_pk.get(Uri.parse('http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?ServiceKey=$ServiceKey&pageNo=1&numOfRows=$numOfRows&dataType=JSON&base_date=$base_date&base_time=$base_time&nx=$nx&ny=$ny'));

    if(response.statusCode == 200) {
      String jsonData = response.body;
      Map<String, dynamic> parsingData = jsonDecode(jsonData);
      var forecastJsonArray = parsingData['response']['body']['items']['item'];

      Map<String, Temperature> dailyForecast = {};
      for (int i = 0; i < int.parse(numOfRows); i+=12) {
        var tmp = 0;
        var tmn = 0;
        var tmx = 0;
        var fcstTime = '';
        for (int j = 0; j < 12; j ++) {
          var forecastObject = Forecast.fromJson(forecastJsonArray[j]);
          if (forecastObject.category == 'TMP') {
            tmp = int.parse(forecastObject.fcstValue);
          } else if (forecastObject.category == 'TMN') {
            tmn = int.parse(forecastObject.fcstValue);
          } else if (forecastObject.category == 'TMX') {
            tmx = int.parse(forecastObject.fcstValue);
          }
        }
        var temperature = Temperature(tmp, tmn, tmx);
        dailyForecast[fcstTime] = temperature;
      }

      context.read<DailyForecast>().updateForecast(dailyForecast);
    }
  }

  String getBaseDate(String date) {
    return date.replaceAll('-', '');
  }

  String getBaseTime(String time) {
    // Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
    // API 제공 시간(~이후) : 02:10, 05:10, 08:10, 11:10, 14:10, 17:10, 20:10, 23:10

    var timeList = time.split(':');
    var now = int.parse(timeList[0] + timeList[1]);
    if (now < 210) {
      return '2300';
    } else if (now >= 210 && now < 510) {
      return '0200';
    } else if (now >= 510 && now < 810) {
      return '0500';
    } else if (now >= 810 && now < 1110) {
      return '0800';
    } else if (now >= 1110 && now < 1410) {
      return '1100';
    } else if (now >= 1410 && now < 1710) {
      return '1400';
    } else if (now >= 1710 && now < 2010) {
      return '1700';
    } else if (now >= 2010 && now < 2310) {
      return '2000';
    } else {
      return '2300';
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    var forecast = context.watch<DailyForecast>().dataList;
    return Scaffold(
      
       appBar: AppBar(
         title: const Text('THis is HomePage'),
       ),
      body: Container(
        child: Column(
          children: [
            const Text('this is Conatiner Col'),
            const Text('hello Col'),

          ],
        ),
      ),
    );
  }
}

