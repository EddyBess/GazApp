import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class QueryTest extends StatefulWidget {
  const QueryTest({super.key});

  @override
  State<QueryTest> createState() => _QueryTestState();
}

class _QueryTestState extends State<QueryTest> {
  Future sendRequest(parameters) async {
    var url = Uri.https(
        "data.economie.gouv.fr", "/api/records/1.0/search/", parameters);
    print(url);
    var response = await http.get(url);

    return response;
  }

  Future getNames() {
    var url =
        Uri.https("eddybess.github.io", "/nomStationsJson/formattedNames.json");

    var response = http.get(url);
    return response;
  }

  var facets = [];

  var jsonNames = {};
  List _position = [];

  Future<Position> _getCurrentLocation() async {
    Position position = await _determinePosition();
    return position;
  }

  @override
  void initState() {
    super.initState();
    getNames().then((res) {
      var names = jsonDecode(res.body);

      setState(() {
        jsonNames = names;
      });
    });
    _getCurrentLocation().then((position) {
      setState(() {
        _position = [
          position.latitude, position.longitude,
          15000
        ];
        print(_position);
        sendRequest({
          'dataset': 'prix-carburants-fichier-instantane-test-ods-copie',
          'facet': 'id',
          'geofilter.distance':
              '${position.latitude},${position.longitude},15000' //Filtre a actualiser en fonction de la position de l'utilisateur
        }).then((res) {
          var temp = jsonDecode(res.body)['facet_groups'][0]['facets'];

          setState(() {
            facets = temp;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Column(
        children: [
          SizedBox(
            height: height * 6 / 100,
          ),
          const Text(
            "Stations à proximité",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: height * 3 / 100,
          ),
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
          ),
          FutureBuilder(
            future: Future.wait(facets
                .map((facet) => sendRequest({
                      'dataset':
                          'prix-carburants-fichier-instantane-test-ods-copie',
                      'refine.id': facet["name"],
                    }))
                .toList()),
            builder: ((context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                var records = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: height * 70 / 100,
                      child: ListView.builder(
                        itemCount: records!.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          var currentStat =
                              jsonDecode(records[index].body)["records"];

                          String prixMaj =
                              currentStat[0]['fields']['prix_maj'] ?? "";
                          var date =
                              prixMaj.length > 1 ? prixMaj.split("T")[0] : "";
                          var hour = prixMaj.length > 1
                              ? prixMaj.split("T")[1].split("+")[0]
                              : "";
                          var dt = date != ""
                              ? DateTime.parse("$date $hour")
                              : DateTime.now();
                          var diff = DateTime.now().difference(dt);
                          var txtDiff = "";

                          if (diff.inDays >= 1 && diff.inDays > 0) {
                            txtDiff = "Il y'a ${diff.inDays} jours";
                          } else if (diff.inHours < 24 && diff.inHours > 0) {
                            txtDiff = "Il y'a ${diff.inHours} heures";
                          } else if (diff.inMinutes < 60 &&
                              diff.inMinutes > 0) {
                            txtDiff = "Il y'a ${diff.inMinutes} minutes";
                          } else if (diff.inSeconds < 60 &&
                              diff.inSeconds > 0) {
                            txtDiff = "Il y'a ${diff.inSeconds} secondes";
                          } else {
                            txtDiff = "Aucune donnée de mise a jour";
                          }

                          if (jsonNames[currentStat[0]['fields']['id']] ==
                              null) {
                            return const Text("");
                          }
                          return Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      offset: Offset(
                                        5.0, // Move to right 10  horizontally
                                        5.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: Card(
                                  color: const Color.fromRGBO(144, 252, 249, 1),
                                  child: SizedBox(
                                    height: height * 30 / 100,
                                    width: width * 90 / 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "${jsonNames[currentStat[0]['fields']['id']]['nom']}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                            "${jsonNames[currentStat[0]['fields']['id']]['marque']}",
                                            style:
                                                const TextStyle(fontSize: 17)),
                                        SizedBox(
                                          height: height * 10 / 100,
                                          width: width * 80 / 100,
                                          child: Center(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: currentStat.length,
                                              itemBuilder: ((context, index) {
                                                var current = currentStat[index]
                                                    ['fields'];

                                                var color =
                                                    const Color.fromRGBO(
                                                        0, 0, 0, 1);
                                                switch (current['prix_nom']) {
                                                  case "SP98":
                                                    color =
                                                        const Color.fromRGBO(
                                                            33, 88, 59, 1);
                                                    break;
                                                  case "Gazole":
                                                    color =
                                                        const Color.fromRGBO(
                                                            237, 217, 0, 1);
                                                    break;
                                                  case "E85":
                                                    color =
                                                        const Color.fromRGBO(
                                                            41, 196, 216, 1);
                                                    break;
                                                  case "GPLc":
                                                    color =
                                                        const Color.fromRGBO(
                                                            29, 106, 148, 1);
                                                    break;
                                                  default:
                                                    color =
                                                        const Color.fromRGBO(
                                                            80, 188, 79, 1);

                                                    break;
                                                }
                                                return current['prix_nom'] !=
                                                        null
                                                    ? Column(
                                                        children: [
                                                          Text(
                                                            "${current['prix_nom']}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          Card(
                                                            color: color,
                                                            child: SizedBox(
                                                              height: height *
                                                                  6 /
                                                                  100,
                                                              width: width *
                                                                  15 /
                                                                  100,
                                                              child: Center(
                                                                  child: Text(
                                                                "${current['prix_valeur']}",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const Text(
                                                        "Rupture",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      );
                                              }),
                                            ),
                                          ),
                                        ),
                                        Text("Dernière mise à jour : $txtDiff")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 5 / 100,
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                );
              } else {
                return const Expanded(
                    child: Center(
                  child: Text(
                      "Aucune station n'a pu etre trouvée dans les environs"),
                ));
              }
            }),
          ),
        ],
      ),
    ));
  }
}
