import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {

  Future getWeather() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final response = await http.get(Uri.parse
      ('http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=28672904e8999g932cc2ed25e060eb963'));
    final data = jsonDecode(response.body);
   return data;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: FutureBuilder(
          future: getWeather(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            final data = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Temp- Max : ${data['main']['temp_max']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Text('Description: ${data['weather'][0]['description']},', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
            );
          }
        ));
  }
}
