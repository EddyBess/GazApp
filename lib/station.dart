import 'dart:convert';

class Station {
  
  final String city;
  final double? gazole;
  final double? sp95;
  final double? sp98;
  final double? e85;


  List<double?> prices = [];
  String name;
  double dist;
  String maj;
 


  // Normal Constructor
  Station(this.city, this.name, this.dist, this.gazole, this.sp95, this.sp98,
      this.e85,this.maj) {
    prices = [gazole, sp95, sp98, e85];
    
    //Converting the name to UTF8 standard to display french accent
    name = const Utf8Decoder().convert(name.codeUnits);

  }

  // Serializer from JSON
  Station.fromJson(Map<String, dynamic> json)
      : city = json['ville'] as String,
        name = json['marque'] as String,
        dist = json['dist'] as double,
        gazole = json["gazole_prix"],
        sp95 = json["sp95_prix"],
        sp98 = json["sp98_prix"],
        e85 = json["e85_prix"],
        maj = json['price_maj']{
    prices = [gazole, sp95, sp98, e85];

    name = const Utf8Decoder().convert(name.codeUnits);

    Duration diff = DateTime.now().difference(DateTime.parse(maj));
    if (diff.inDays >= 1 ) {
      maj = diff.inDays >1 ? "Il y'a ${diff.inDays} jours":"Il y'a ${diff.inDays} jour";
    } else if (diff.inHours < 24 && diff.inHours > 0) {
      maj = diff.inHours>1 ? "Il y'a ${diff.inHours} heures": "Il y'a ${diff.inHours} heure";
    } else if (diff.inMinutes < 60 &&
        diff.inMinutes > 0) {
      maj = diff.inMinutes>1?"Il y'a ${diff.inMinutes} minutes":"Il y'a ${diff.inMinutes} minute";
    } else if (diff.inSeconds < 60 &&
        diff.inSeconds > 0) {
      maj = diff.inSeconds>1?"Il y'a ${diff.inSeconds} secondes":"Il y'a ${diff.inSeconds} seconde";
    } else {
      maj = "Aucune donnée de mise a jour";
    }




  }
}
