import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_project/secrets.dart';
import 'package:weather_app_project/widgets/additional_item_widget.dart';
import 'package:weather_app_project/widgets/hourly_forecast__item_widget.dart';
import 'package:weather_app_project/widgets/title_text_widget.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  String cityName = 'London';
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrencyWeather() async {

    final weatherApi = 'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherApiKey';

    try {
      final res = await http.get(Uri.parse(
        weatherApi));
      final data = jsonDecode(res.body);

      if (data['cod'].toString() != '200') {
        throw data['message'];
      }


      return data;

    } catch(e){
      print(e);
      throw e.toString();
    }
  }
@override
  void initState() {
    super.initState();
    weather = getCurrencyWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            print('refresh');
            setState(() {
              weather = getCurrencyWeather();
            });
          },
              icon: const Icon(Icons.refresh)),]
      ),
      body:  FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            print(snapshot);

            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if(snapshot.hasError){
              return  Center(child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data!;

            final  currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'];

            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentHumidity = currentWeatherData['main']['humidity'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];


            return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(
                          width: double.infinity,
                          child:   Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10
                                ),
                                child:  Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text('$currentTemp K', style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold

                                      ),),
                                      SizedBox(height: 16,),

                                  Icon(currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud : Icons.sunny, size: 64,),
                                      SizedBox(height: 16,),
                                      Text('$currentSky', style: TextStyle(
                                          fontSize: 20
                                      ),)

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TitleTextWidget(title: 'Weather Forecast',),
                  const SizedBox(height: 8,),
                  SizedBox(
                    height: 120, // give it a fixed height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data['list'].length - 1,
                        itemBuilder: (context, index)  {
                          final hourlyforecast = data['list'][index+1];
                          final hourlySky = data['list'][index+1]['weather'][0]['main'];
                          final time = DateTime.parse(hourlyforecast['dt_txt']);
                          

                          return    HourlyForecastWidget(
                                time: DateFormat.j().format(time),
                                icon: hourlySky == 'Clouds' || hourlySky == 'Rain'  ? Icons.cloud : Icons.sunny,
                                temperature: hourlyforecast['main']['temp'].toString());
                        }
                    ),

                  ),
                  const SizedBox(height: 20,),
                  TitleTextWidget(title: 'Additional Information',),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CardWidget(icon: Icons.water_drop,title: 'Humidity', value: currentHumidity.toString(),),
                      CardWidget(icon: Icons.air,title: 'Wind Speed', value: currentWindSpeed.toString(),),
                      CardWidget(icon: Icons.beach_access,title: 'Pressure', value: currentPressure.toString(),),
                    ],
                  )

                ],
              ),
            ),
          );
          },)
    );
  }
}








