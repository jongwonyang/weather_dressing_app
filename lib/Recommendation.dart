import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:team_project1/forecast.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final top = [
    ['1-top-1.png', '1-top-2.png'],
    ['2-top-1.png'],
    ['3-top-1.png', '3-top-2.png'],
    ['4-top-1.png', '4-top-2.png'],
    ['5-top-1.png'],
    ['6-top-1.png', '6-top-2.png'],
    ['7-top-1.png', '7-top-2.png'],
    ['8-top-1.png', '8-all-1.png']
  ];
  final bot = [
    ['1-acc-1.png'],
    ['2-acc-1.png', '2-acc-2.png'],
    ['3-bot-1.png'],
    ['4-bot-1.png'],
    ['5-bot-1.png', '5-bot-2.png'],
    ['6-bot-1.png'],
    ['7-bot-1.png'],
    ['8-bot-1.png']
  ];
  final descriptions = [
    ['패딩', '두꺼운코트', '목도리', '기모제품'],
    ['코트', '가죽자켓', '히트텍', '니트', '레깅스'],
    ['자켓', '트렌치코트', '야상', '니트', '청바지', '스타킹'],
    ['자켓', '가디건', '야상', '스타킹', '청바지', '면바지'],
    ['얇은니트', '맨투맨', '가디건', '청바지'],
    ['얇은가디건', '긴팔', '면바지', '청바지'],
    ['반팔', '얇은셔츠', '반바지', '면바지'],
    ['민소매', '반팔', '반바지', '원피스']
  ];
  CarouselController controller = CarouselController();
  final _authentication = FirebaseAuth.instance;
  var hour = DateTime.now().hour * 100;

  int getTemperature() {
    var temperature = context.read<DailyForecast>().dataList[hour];
    var avg = (temperature!.tmn + temperature.tmx) / 2;
    if (avg >= 27) {
      return 8;
    } else if (avg >= 23) {
      return 7;
    } else if (avg >= 20) {
      return 6;
    } else if (avg >= 17) {
      return 5;
    } else if (avg >= 12) {
      return 4;
    } else if (avg >= 10) {
      return 3;
    } else if (avg >= 1) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Row(
            children: const [
              Text(
                '오늘의 코디',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        context.watch<DailyForecast>().dataList[hour] == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('records')
                    .where('user',
                        isEqualTo: _authentication.currentUser!.email)
                    .where('tempcode', isEqualTo: getTemperature())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          CarouselSlider.builder(
                            options: CarouselOptions(
                              viewportFraction: 1.0,
                              aspectRatio: 1.0,
                            ),
                            itemCount: docs.length + 1,
                            itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) {
                              return InkWell(
                                onTap: () {
                                  if (itemIndex != 0) {
                                    print(docs[itemIndex - 1].id.toString());
                                  }
                                  // TODO
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (itemIndex == 0)
                                      Column(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/images/${top[getTemperature() - 1][Random().nextInt(top[getTemperature() - 1].length)]}'),
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.contain,
                                          ),
                                          Image(
                                            image: AssetImage(
                                                'assets/images/${bot[getTemperature() - 1][Random().nextInt(bot[getTemperature() - 1].length)]}'),
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.contain,
                                          ),
                                        ],
                                      )
                                    else
                                      Container(
                                        width: 400,
                                        height: 240,
                                        child: FittedBox(
                                          clipBehavior: Clip.hardEdge,
                                          fit: BoxFit.cover,
                                          child: Image.file(File(docs[itemIndex - 1]
                                                  ['image']
                                              .replaceAll("File:", "")
                                              .replaceAll("'", "")
                                              .trim())),
                                        ),
                                      ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      '${itemIndex + 1} / ${docs.length + 1}',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: (itemIndex == 0)
                                          ? Row(
                                              children: descriptions[
                                                      getTemperature() - 1]
                                                  .map((e) {
                                                return Text('#$e ');
                                              }).toList(),
                                            )
                                          : Row(
                                              children: [
                                                Text(docs[itemIndex - 1]
                                                    ['description']),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
