import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:google_fonts/google_fonts.dart';

  
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp( MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily
      ),
    )
  );
}

