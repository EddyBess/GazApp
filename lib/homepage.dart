import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gassapp/station.dart';
import 'package:gassapp/card_component.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
//Import des fichiers
import 'locationFunctions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double currentSliderValue = 10;
  Future<Map<String, dynamic>> createParameters() async {
    Position position = await determinePosition();

    Map<String, dynamic> parameters = {
      "location":"${position.longitude},${position.latitude}",
      "distance": "$currentSliderValue"
    };
    return parameters;
  }

  Future<http.Response> getData(Map<String, dynamic> parameters) async {

    Uri queryUrl = Uri.http("127.0.0.1:8000", "/", parameters);

    http.Response response = await http.get(queryUrl);
    
    return response;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    createParameters();
    return Scaffold(
      body: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.08,
            ),
            const Text(
              "Stations à proximité",
              style: TextStyle(fontSize: 20),
            ),
            FutureBuilder(
                future: createParameters(),
                builder: ((context, snapshot) {

                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return FutureBuilder(
                        future: getData(snapshot.data!),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {                              
                            var data = jsonDecode(snapshot.data!.body);
                            return SizedBox(
                              width: width*0.9,
                              height: height*0.75,
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  Station station = Station.fromJson(data[index]);
                                  return SizedBox(
                                    width: width,
                                    child: Column(
                                      children: [
                                        CardComponent(station: station),
                                        Divider(height: height*0.03,)
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: height*0.75,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        }));
                  } else {
                    return SizedBox(
                      height: height*0.75,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })),
                Column(
                  children: [
                    Slider(
                      min: 5,
                      max: 100,
                      divisions: 19,
                      value: currentSliderValue, onChanged: ((value) {
                      setState(() {
                        currentSliderValue = value;
                        createParameters();
                      });
                    })),
                    Text("Dans un rayon de ${currentSliderValue.round()}km")
                  ],
                )
          ],
        ),
      ),
    );
  }
}
