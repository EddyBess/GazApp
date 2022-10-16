import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class QueryTest extends StatefulWidget {
  const QueryTest({super.key});

  @override
  State<QueryTest> createState() => _QueryTestState();
}

class _QueryTestState extends State<QueryTest> {
  Future sendRequest(parameters) async {
    var url = Uri.https(
        "data.economie.gouv.fr", "/api/records/1.0/search/", parameters);

    var response = await  http.get(url);
    
    return response;
  }
  Future getNames()  {
    var url = Uri.https(
        "eddybess.github.io", "/nomStationsJson/formattedNames.json");

    var response = http.get(url);
    return response;
  }
 
  var facets = [];
  
  var jsonNames = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNames().then((res){
      var names = jsonDecode(res.body);
  
       setState(() {
        jsonNames = names;

       });
  
    });
    sendRequest({
      'dataset': 'prix-carburants-fichier-instantane-test-ods-copie',
      'facet': 'id',
      'refine.com_name':'Sierentz' //Filtre a actualiser en fonction de la position de l'utilisateur 
    }).then((res) {
     
      var temp = jsonDecode(res.body)['facet_groups'][0]['facets'];
     
        setState(() {
      
        facets = temp;
      
      });
      });
      
      
   
  }
  
  @override
  Widget build(BuildContext context) {
  

    
  

    
    
    return Scaffold(
      body: Column(
        children: [
          
          FutureBuilder(
            future: Future.wait(facets.map((facet) => sendRequest({
              'dataset': 'prix-carburants-fichier-instantane-test-ods-copie',
              'refine.id': facet["name"],
              })).toList()),
          builder: ((context, AsyncSnapshot<List<dynamic>> snapshot) {
       
            if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
              
              var records = snapshot.data;
            
              return  Column(
                children: [
                  ListView.builder(
                  itemCount: records!.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    
                    var currentStat = jsonDecode(records[index].body)["records"];
                    if (jsonNames[currentStat[0]['fields']['id']] ==null){
                      return const Text("");
                    }
                    return Column(
                      
                      children: [
                        
                        Text("Station : ${jsonNames[currentStat[0]['fields']['id']]['nom']}"),
                        Text("Marque : ${jsonNames[currentStat[0]['fields']['id']]['marque']}"),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              
                              scrollDirection: Axis.horizontal,
                              itemCount: currentStat.length,
                              itemBuilder: ((context, index) {
                                var current = currentStat[index]['fields'];
                                return Text("${current['prix_nom']} : ${current['prix_valeur']} ");
                                
                              }),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            
            ),
          
                ],
              );
              
              
            
            }
            else{
            
              return const Expanded(child:  Center(child: Text("Aucune station n'a pu etre trouvée dans les environs"),));
            }

          }
          
          
          ) ,








           
          ),
          Center(child: ElevatedButton(onPressed: (){setState(() {
            
          });}, child:const  Text("ACTUALISER"))),
        ],
      ));
  }
}
