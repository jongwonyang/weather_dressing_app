import 'package:flutter/material.dart';
import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    final topImage = top[temperatureSection - 1][Random().nextInt(top[temperatureSection - 1].length)];
    final botImage = bot[temperatureSection - 1][Random().nextInt(bot[temperatureSection - 1].length)];

    return Column(
      children: [
        Image(image: AssetImage('assets/$topImage')),
        Image(image: AssetImage('assets/$botImage'))
      ],
    );
  }
}