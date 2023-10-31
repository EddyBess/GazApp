import 'package:flutter/material.dart';
import 'station.dart';

class CardComponent extends StatefulWidget {
  final Station station;
  const CardComponent({super.key, required this.station});

  @override
  State<CardComponent> createState() => _CardComponentState();
}

class _CardComponentState extends State<CardComponent> {
  List<Color> colors = [
    const Color(0xFFe8e515),
    const Color(0xFF56ba49),
    const Color(0xFF004a26),
    const Color(0xFF29c0d6)
  ];
  List<String> names = ["Diesel", "SP95", "SP98", "E85"];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.2,
      width: width,
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xFF66CC66),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RichText(text: 
              TextSpan(
                text: "${widget.station.name} ",
                style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                children: [
                  TextSpan(text: "${widget.station.city},${widget.station.dist.toStringAsFixed(0)} km",style: const TextStyle(fontWeight: FontWeight.normal)),
                ]
              )
              ,),
             
              SizedBox(
                height: height * 0.1,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.station.prices.length,
                    itemBuilder: ((context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: width * 0.15,
                                height: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          widget.station.prices[index] != null
                                              ? colors[index]
                                              : Colors.red,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Text(widget
                                                  .station.prices[index] !=
                                              null
                                          ? "${widget.station.prices[index]}"
                                          : "9.999",style: const TextStyle(fontWeight: FontWeight.bold),)
                                          ),
                                ),
                              ),
                              const Divider(
                                height: 5,
                                color: Colors.transparent,
                              ),
                              Text(names[index],style: TextStyle(fontStyle: widget.station.prices[index]!=null ? FontStyle.normal:FontStyle.italic) ,),
                            ],
                          ),
                          SizedBox(
                            width: width * 0.03,
                          )
                        ],
                      );
                    })),
              ),
              Text(widget.station.maj)
            ]),
      ),
    );
  }
}
