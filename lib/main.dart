import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'querytest.dart';


  
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp( MaterialApp(
     
      theme: ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily ),
      home: const QueryTest(),
    )
  );
}

