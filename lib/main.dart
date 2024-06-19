import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Placeholder previsualise l'endroit et la taille du prochain widget
    //return const Placeholder();
    return MaterialApp(
      //debugShowCheckedModeBanner pour enlever le bandeau debug 
      debugShowCheckedModeBanner: false,
      //il y a des theme predefinit, exemple ThemeData.dark()
      //ou ThemeData.light()

      //ThemeData.dark(useMaterial3: true).copyWith() pour avoir le theme
      //dark mais override tout de meme les proprietes que je veux
      theme: ThemeData.dark(useMaterial3: true),
      home: const WeatherScreen(),
    );
  }
}