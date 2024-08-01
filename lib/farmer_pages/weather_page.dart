import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  late Future<Map<String, dynamic>> weather;
  @override
  void initState(){
    super.initState();
    weather = getCurrentWeather('nuzvid');
  }

  String currentCity = 'nuzvid';

  Future<Map<String, dynamic>> getCurrentWeather(city) async {
    final apiKey = dotenv.env['API_KEY'];
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?units=metric&q=$city&appid=$apiKey',
        )
      );
      final data = jsonDecode(res.body);

      setState(() {
        currentCity = city;
      });

      if(data['cod'] != '200'){
        throw "An Unexpected Error";
      }
      return data;
    }catch (e) {
      throw e.toString();
    }
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString())
              );
          }

          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final currentWeather = data['list'][0]['weather'][0]['main'];
          final humidity = data['list'][0]['main']['humidity'];
          final wind = data['list'][0]['wind']['speed'];
          final pressure = data['list'][0]['main']['temp'];

          final weathers = data['list'];

          return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter your city",
                    hintStyle: TextStyle(
                      color: (Theme.of(context).brightness == Brightness.dark) ? Colors.white : Colors.black,
                    ),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          weather = getCurrentWeather(textEditingController.text);
                        });
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                currentCity.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$currentTemp °C',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    currentWeather == 'Clouds' || currentWeather == 'Rain' ? Icons.cloud : Icons.sunny,
                                    size: 40,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "$currentWeather",
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 40),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder:(context, index) {
                      final time = DateTime.parse(weathers[index + 2]['dt_txt']);
                      final weathernow = weathers[index + 2]['weather'][0]['main'];
                      final tempnow = weathers[index + 2]['main']['temp'].toString();
                      return ForecastWidget(
                        icon: weathernow == 'Clouds' || weathernow == 'Rain' ? Icons.cloud : Icons.sunny,
                        time: DateFormat.Hm().format(time),
                        temp: '$tempnow °C',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        prop: "Humidity",
                        value: '$humidity',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        prop: "Wind Speed",
                        value: '$wind',
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        prop: "Pressure",
                        value: '$pressure',
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String prop;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.prop,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 45,
        ),
        const SizedBox(height: 10),
        Text(
          prop,
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
class ForecastWidget extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const ForecastWidget({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 10),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              temp,
            )
          ],
        ),
      ),
    );
  }
}