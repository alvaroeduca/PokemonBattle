import 'package:flutter/material.dart';

class TypeContainer {
  static final Map<String, Color?> _typeColors = {
    "grass" : Colors.lightGreenAccent,
    "poison" : Colors.purple[200],
    "fire" : Colors.red,
    "flying" : Colors.blue[100],
    "water" : Colors.blue,
    "bug" : Colors.lightGreen,
    "ground" : Colors.brown,
    "fairy" : Colors.pinkAccent,
    "electric" : Colors.amberAccent,
    "ghost" : Colors.purple,
    "dark" : Colors.black12,
    "rock" : Colors.brown[400],
    "psychic" : Colors.brown[400],
    "ice" : Colors.lightBlueAccent,
    "dragon" : Colors.lightBlueAccent,
  };
  String? typename;
  Color? color;

  TypeContainer({required this.typename}) {
    color = _typeColors.containsKey(typename) ? _typeColors[typename] : Colors.yellow;
  }
}