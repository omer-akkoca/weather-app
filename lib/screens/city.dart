import "package:flutter/material.dart";
import "package:weather/screens/location.dart";
import "package:weather/services/networking.dart";
import "package:weather/utils/contants.dart";
import 'package:rflutter_alert/rflutter_alert.dart';

class City extends StatefulWidget {
  const City({super.key});

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
  String query = "";

  var txt = TextEditingController();

  void getWeatherWithCityName() async {
    String url = "$weatherURL?q=$query&appid=$apiKey&units=metric";
    NetworkHelper networkHelper = NetworkHelper(url: url);
    var weatherData = await networkHelper.getData();

    if (!context.mounted) return;

    if (weatherData == 404) {
      Alert(
        context: context,
        title: "Invalid City Name",
        desc: "Please type a valid city name.",
        buttons: [
          DialogButton(
            onPressed: (){
              setState(() {
                query = "";
              });
              txt.text = "";
              Navigator.pop(context);
            },
            child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
          )
        ]
      ).show();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Location(locationWeather: weatherData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/city_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: txt,
                  onChanged: (e) {
                    setState(() {
                      query = e;
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: Icon(
                      Icons.apartment,
                      color: Colors.white,
                    ),
                    hintText: "Type a city name...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: getWeatherWithCityName,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        "Get Weather",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
