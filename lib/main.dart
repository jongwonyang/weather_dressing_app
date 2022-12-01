import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http_pk;
import 'dart:convert';
import 'calculate.dart';
import 'forecast.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DailyForecast(),
      builder: (context, child) => MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: MyHomePage(title: 'Weather App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() async {
      _counter++;
    });
  }

  void getWeather() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var latitude = position.latitude;
    var longitude = position.longitude;

    WeatherMapXY weathermapxy = changelaluMap(longitude, latitude);
    var nx = weathermapxy.x.toString();
    var ny = weathermapxy.y.toString();

    String numOfRows = '10';
    var dateTime = DateTime.now().toString().split(' ');
    String base_date = getBaseDate(dateTime[0]);
    String base_time = getBaseTime(dateTime[1]);

    const ServiceKey = '7o4wY20Oec3aLc6GSWaZYqOl%2BWM%2Bd9I0TOkWUM15tF3qShnUAmVFV%2BM%2BTWkn9g8TocHyzYjDpU5o7iaOLEKVsA%3D%3D';
    http_pk.Response response = await http_pk.get(Uri.parse('http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?ServiceKey=$ServiceKey&pageNo=1&numOfRows=$numOfRows&dataType=JSON&base_date=$base_date&base_time=$base_time&nx=$nx&ny=$ny'));

    if(response.statusCode == 200) {
      String jsonData = response.body;
      Map<String, dynamic> parsingData = jsonDecode(jsonData);
      var forecastJsonArray = parsingData['response']['body']['items']['item'];

      List<Forecast> forecastObjectList = <Forecast>[];
      for (var forecast in forecastJsonArray) {
        var forecastObject = Forecast.fromJson(forecast);
        forecastObjectList.add(forecastObject);
      }

      context.read<DailyForecast>().updateForecast(forecastObjectList);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
