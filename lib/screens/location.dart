import "package:flutter/material.dart";
import "package:weather/screens/city.dart";
import "package:weather/services/weather_model.dart";

class Location extends StatefulWidget {
  final dynamic locationWeather;

  const Location({super.key, required this.locationWeather});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late String name;
  late int temp;
  late String weatherIcon;
  late String message;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    if (weatherData == null) {
      setState(() {
        name = "-";
        temp = 0;
        weatherIcon = "empty";
        message = "Unable to get weather data.";
      });
      return;
    }
    WeatherModel weatherModel = WeatherModel();
    int condition = weatherData["weather"][0]["id"];
    double doubleTemp = weatherData["main"]["temp"];
    setState(() {
      name = weatherData["name"];
      temp = doubleTemp.toInt();
      weatherIcon = weatherModel.getWeatherIcon(condition);
      message = weatherModel.getMessage(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/location_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: const Icon(Icons.near_me,
                        color: Colors.white, size: 30),
                    onTap: () async {
                      WeatherModel weathermodel = WeatherModel();
                      dynamic weatherData = await weathermodel.getWeatherData();
                      updateUI(weatherData);
                    },
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const City(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          "$temp°",
                          style: const TextStyle(
                              fontSize: 100, fontFamily: "spartan"),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          weatherIcon,
                          style: const TextStyle(fontSize: 100),
                        )
                      ],
                    ),
                    Text(
                      "$message in $name.",
                      style: const TextStyle(
                          fontSize: 50, fontFamily: "spartan"),
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
