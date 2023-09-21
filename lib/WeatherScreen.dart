import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/OtherWeatherStats.dart';
import 'package:weather_app/WeatherCard.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather("Bengaluru", "in");
  }

  double temp = 0;

  Future<Map<String,dynamic>> getCurrentWeather(String city, String country) async {
    String url = "https://api.openweathermap.org/data/2.5/forecast?q=$city,$country&APPID=$openWeatherApiKey";
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    if (data['cod'] != '200') {
      throw "An unexpected error occurred";
    }
    temp = data['list'][0]['main']['temp'];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: const Text("Weather App",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {setState(() {

          });}, icon: const Icon(Icons.refresh_outlined))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather("Bengaluru", "in"),
        builder: (context,snapshot) {
          print(snapshot);
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final curTemp = data['list'][0]['main']['temp'];
          final curSky = data['list'][0]['weather'][0]['main'];
          final curhum = double.parse(data['list'][0]['main']['humidity'].toString());
          final curPres = double.parse(data['list'][0]['main']['pressure'].toString());
          final curWind = double.parse(data['list'][0]['wind']['speed'].toString());


          return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 7,
              ),
              // Main Card
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "$curTemp°K",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                            const SizedBox(height: 20),
                            Icon(curSky == "Clouds" || curSky == "Rain" ? Icons.cloud: Icons.sunny, size: 64),
                            const SizedBox(height: 10),
                             Text(
                              "$curSky",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Spacing
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Forecast Cards
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for(int i = 1; i <= 10; i++)
              //         HourlyForecastItem(
              //             time: DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(data['list'][i]['dt']*1000)),
              //             temp: data['list'][i]['main']['temp'].toString(),
              //             icon: data['list'][i]['weather'][0]['main']).createCard()
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: 20,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                    final hourlyforecast = data['list'][index];
                      return HourlyForecastItem(
                          time: DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(hourlyforecast['dt']*1000)),
                          temp: hourlyforecast['main']['temp'].toString(),
                          icon: hourlyforecast['weather'][0]['main']).createCard();
                    }
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OtherWeatherStats(statType: "humidity", value: curhum).createStat(),
                  OtherWeatherStats(statType: "wind", value: curWind).createStat(),
                  OtherWeatherStats(statType: "pressure", value: curPres)
                      .createStat()
                ],
              )
            ],
          ),
        );
        },
      ),
    );
  }
}
