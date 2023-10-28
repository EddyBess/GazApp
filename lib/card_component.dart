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
    print(widget.station.prices);
    print(widget.station.name);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.2,
      width: width,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  "${widget.station.name} ${widget.station.city} à ${widget.station.dist}km"),
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
                                      color: colors[index],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${widget.station.prices[index]}"),
                                    ],
                                  ),
                                ),
                              ),
                              Text(names[index]),
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
