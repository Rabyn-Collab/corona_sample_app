import 'package:flutter/material.dart';
import 'package:flutter_ex/screens/corona_meter.dart';
import 'package:flutter_ex/screens/home_screen.dart';
import 'package:flutter_ex/screens/weather_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: Home()));
}


class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CoronaMeter(),
    );
  }
}
