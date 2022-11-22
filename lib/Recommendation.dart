import 'package:flutter/material.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final temperatureSection = 3;
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
  int currentIndex = 0;
  final itemCount = 5;

  @override
  Widget build(BuildContext context) {
    final topImage = top[temperatureSection - 1]
        [Random().nextInt(top[temperatureSection - 1].length)];
    final botImage = bot[temperatureSection - 1]
        [Random().nextInt(bot[temperatureSection - 1].length)];

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
        Padding(
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
                        onPageChanged: (val, _) {
                          setState(() {
                            currentIndex = val;
                          });
                        }),
                    itemCount: itemCount,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      if (itemIndex == 0) {
                        return Column(
                          children: [
                            Image(
                              image: AssetImage('assets/$topImage'),
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            Image(
                              image: AssetImage('assets/$botImage'),
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            )
                          ],
                        );
                      }
                      return Container(child: Text(itemIndex.toString()));
                    }),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(itemCount, (i) {
                    if (i == currentIndex) {
                      return Container(
                        margin: const EdgeInsets.all(2.0),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.all(2.0),
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: Color(0xFFd2d2d2), shape: BoxShape.circle),
                      );
                    }
                  }),
                ),

                /*
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image(image: AssetImage('assets/$topImage')),
                        Image(image: AssetImage('assets/$botImage'))
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ],
    );
  }
}
