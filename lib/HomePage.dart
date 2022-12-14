import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http_pk;
import 'package:team_project1/InitialPostPage.dart';
import 'package:team_project1/Recommendation.dart';
import 'package:team_project1/RecordList.dart';
import 'dart:convert';
import 'calculate.dart';
import 'forecast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    ListView(
      children: const [
        WeatherWidget(),
        // Text('weather'),
        Recommendation(),
      ],
    ),
    const RecordListWidget()
  ];

  final List<Widget> _appBarOptions = [
    const Text(
      '기온별 옷차림',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    const Text(
      '일기 리스트',
      style: TextStyle(fontWeight: FontWeight.bold),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4055f2),
        title: _appBarOptions[_selectedIndex],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.logout)
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xff4055f2),
        selectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.collections), label: 'Records')
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: _selectedIndex == 0
          ? null
          : FloatingActionButton(
        backgroundColor: Color(0xff4055f2),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TestPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Future<Map<int, Temperature>> _getWeather() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var latitude = position.latitude;
    var longitude = position.longitude;
    print(latitude);
    print(longitude);

    WeatherMapXY weathermapxy = changelaluMap(-longitude, latitude);
    var nx = (-weathermapxy.x).toString();
    var ny = weathermapxy.y.toString();
    print(nx);
    print(ny);

    String numOfRows = '120';
    var dateTime = DateTime.now().toString().split(' ');
    String base_date = getBaseDate(dateTime[0]);
    String base_time = getBaseTime(dateTime[1]);
    base_date = (int.parse(base_date)-1).toString();
    print(base_date);
    print(base_time);

    const ServiceKey =
        '7o4wY20Oec3aLc6GSWaZYqOl%2BWM%2Bd9I0TOkWUM15tF3qShnUAmVFV%2BM%2BTWkn9g8TocHyzYjDpU5o7iaOLEKVsA%3D%3D';
    http_pk.Response response = await http_pk.get(Uri.parse(
        'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?ServiceKey=$ServiceKey&pageNo=1&numOfRows=$numOfRows&dataType=JSON&base_date=$base_date&base_time=$base_time&nx=$nx&ny=$ny'));

    Map<int, Temperature> dailyForecast = {};
    if (response.statusCode == 200) {
      String jsonData = response.body;
      Map<String, dynamic> parsingData = jsonDecode(jsonData);
      var forecastJsonArray = parsingData['response']['body']['items']['item'];
      print(forecastJsonArray);


      var tmpList = [];
      var fcstTime = DateTime.now().hour * 100;
      if (fcstTime == 2400) {
        fcstTime = 0;
      }
      for (int i = 0; i < int.parse(numOfRows); i += 12) {
        var sky = 0;
        var pty = 0;
        var tmp = 0;

        for (int j = 0; j < 12; j ++) {
          var forecastObject = Forecast.fromJson(forecastJsonArray[i+j]);
          // fcstTime = forecastObject.fcstTime;
          if (forecastObject.category == 'TMP') {
            tmp = int.parse(forecastObject.fcstValue);
            tmpList.add(tmp);
          } else if (forecastObject.category == 'SKY') {
            sky = int.parse(forecastObject.fcstValue);
          } else if (forecastObject.category == 'PTY') {
            pty = int.parse(forecastObject.fcstValue);
          }
        }

        if (i == 0) {
          var temperature = Temperature(sky, pty, tmp, 0, 0);
          dailyForecast[fcstTime] = temperature;
        }
      }
      tmpList.sort();
      dailyForecast[fcstTime]?.tmn = tmpList.first;
      dailyForecast[fcstTime]?.tmx = tmpList.last;
    }
    context.read<DailyForecast>().updateForecast(dailyForecast);
    return dailyForecast;
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
    var dailyForecast = _getWeather();
    dailyForecast
        .then((value) => context.read<DailyForecast>().updateForecast(value));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
            future: _getWeather(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              } else {
                var forecast = snapshot.data;

                var hour = DateTime.now().hour * 100;
                if (hour == 2400) {
                  hour = 0;
                }
                print(hour);

                if (forecast[hour] == null) {
                  hour = DateTime.now().hour * 100;
                }
                if (hour == 2400) {
                  hour = 0;
                }

                var imageURL = '';

                var sky = forecast[hour].sky;
                if (sky == 1) {
                  imageURL = 'assets/images/sunny.JPG';
                } else if (sky == 3) {
                  imageURL = 'assets/images/littlecloud.JPG';
                } else if (sky == 4) {
                  imageURL = 'assets/images/cloudy.JPG';
                }

                var pty = forecast[hour].pty;
                if (pty == 1 || pty == 2) {
                  imageURL = 'assets/images/rain.JPG';
                } else if (pty == 3) {
                  imageURL = 'assets/images/snow.JPG';
                } else if (pty == 4) {
                  imageURL = 'assets/images/shortrain.JPG';
                }

                return Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Image.asset(imageURL)),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('최저 기온'),
                                  Text('${forecast[hour].tmn} °C'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('현재 기온'),
                                  Text('${forecast[hour].tmp} °C'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('최고 기온'),
                                  Text('${forecast[hour].tmx} °C'),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ));
              }
            }));
  }
}