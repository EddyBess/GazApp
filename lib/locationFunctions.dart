import 'dart:math';

int getDist(stationCoords,currentCoords){
  var toRad = (180/pi);
  var x1 = stationCoords[0]/toRad;
  var x2 =  currentCoords[0]/toRad;

  var y1 = stationCoords[1]/toRad;
  var y2 =  currentCoords[1]/toRad;

  var dlon  = y1-y2;
  var dlat = x1-x2;

  var a = pow(sin(dlat/2),2) + cos(x2) * cos(x1) * pow(sin(dlon/2),2);
  var c = 2*asin(sqrt(a));
  var r = 6371;
  var dist = c*r;

  return dist.round();

}