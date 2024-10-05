import 'dart:async';

import 'package:glance/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Glance',
        theme: ThemeData(
          useMaterial3: true,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),

          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.black,
            secondary: Colors.black,
            brightness: Brightness.light,
          ),

          textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: GoogleFonts.lato(
              fontSize: 30,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
            ),
            displaySmall: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        darkTheme: ThemeData(
          useMaterial3: true,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.red,  // Specify the color you want for your selected item
            unselectedItemColor: Colors.grey,  // Specify the color you want for your unselected items
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: Colors.white,
            secondary: Colors.white,
            brightness: Brightness.dark,
          ),
          textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
            // ···
            titleLarge: GoogleFonts.lato(
              fontSize: 30,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
            ),
            displaySmall: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: LoginScreen()
    );
  }
}