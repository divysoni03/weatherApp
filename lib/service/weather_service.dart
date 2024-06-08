import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../model/weathermodel.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final responce = await http
        .get(Uri.parse('$BASE_URL?=$cityName&appid=$apiKey&units=metric'));

    if (responce.statusCode == 200) {
      return Weather.fromJson(jsonDecode(responce.body));
    } else {
      throw Exception('Failed to load Weather Data');
    }
  }

  Future<String> getCurrentCity() async {
    //for getting permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert location into a list of placemark object
    List<Placemark> placemarks =  
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
