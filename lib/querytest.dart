import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QueryTest extends StatefulWidget {
  const QueryTest({super.key});

  @override
  State<QueryTest> createState() => _QueryTestState();
}

class _QueryTestState extends State<QueryTest> {
  Future sendRequest(parameters) async {
    var url = Uri.https(
        "data.economie.gouv.fr", "/api/records/1.0/search/", parameters);

    var response = http.get(url);
    return response;
  }
  

  var records = [];
  var names = [];
  var jsonNames = {};
  @override
  Widget build(BuildContext context) {


    sendRequest({
      'dataset': 'prix-carburants-fichier-instantane-test-ods-copie',
      
      'facet': 'id',
      'geofilter.distance':'47.493,7.636,15000'
    }).then((res) {
     
      var facets = jsonDecode(res.body)['facet_groups'][0]['facets'];
      for (var i = 0; i < facets.length; i++) {
        sendRequest({
          'dataset': 'prix-carburants-fichier-instantane-test-ods-copie',
          'refine.id': facets[i]['name'],
        }).then((res) {
          if (records.length<facets.length){
            setState(() {
            records.add(jsonDecode(res.body)['records']);
              
            });

          }
            
          
        });
      }
    });

    
    return Scaffold(
      body: ListView.builder(
        itemCount: records.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          
          var current_stat = records[index];

          return Column(
            
            children: [
              Text("Station se situant à ${current_stat[0]['fields']['com_name']} "),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    
                    scrollDirection: Axis.horizontal,
                    itemCount: current_stat.length,
                    itemBuilder: ((context, index) {
                      var current = current_stat[index]['fields'];
                      return Text("${current['prix_nom']} : ${current['prix_valeur']} ");
                      
                    }),
                  ),
                ),
              ),
            ],
          );
        }),
      ));
  }
}
