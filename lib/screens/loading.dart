import "package:flutter/material.dart";
import 'package:weather/screens/location.dart';
import 'package:weather/services/weather_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    WeatherModel weathermodel = WeatherModel();

    dynamic weatherData = await weathermodel.getWeatherData();

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Location(locationWeather: weatherData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SpinKitRotatingCircle(
      color: Colors.white,
      size: 50.0,
    ));
  }
}
