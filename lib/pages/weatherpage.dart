import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/model/weathermodel.dart';
import 'package:weather_app/service/weather_service.dart';

class weatherpage extends StatefulWidget {
  const weatherpage({super.key});

  @override
  State<weatherpage> createState() => _weatherpageState();
}

class _weatherpageState extends State<weatherpage> {
  //api key
  final _weatherService = WeatherService('26a2356295818e30a747c99e5d9f361d');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //if any error ocurs
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? maincondition) {
    // Check if maincondition is null or empty and default to 'sunny'
    if (maincondition == null || maincondition.isEmpty) {
      return 'assets/sunny.json';
    }

    // Convert maincondition to lowercase
    String condition = maincondition.toLowerCase();

    // Use switch-case to determine the appropriate animation
    switch (condition) {
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //INIT state
  void initstate() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //cityname 
          Text(_weather?.cityName ?? "Loading city...."),

          //animations
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition ?? "sunny")),

          //temparature
          Text("${_weather?.temparature}•C"),

          //weather condition
          Text(_weather?.mainCondition ?? "")
        ],
      ),
    );
  }
}
