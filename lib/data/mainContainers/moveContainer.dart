import 'package:pokegrid/data/mainContainers/typeContainer.dart';
import 'package:flutter/material.dart';

class MoveContainer {
  String name = "";
  int damage = 0;
  TypeContainer? moveType;
  int probabilities = 0;

  MoveContainer({required this.name, required this.damage, required this.moveType});

  Color? getColor() {
    return moveType?.color;
  }

  MoveContainer.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    if(json.containsKey("power")) {
      damage = json["power"] ?? 0 ;
    }
    if(json.containsKey("type")) {
      moveType = TypeContainer(typename: json['type']['name'] as String);
    }
    if(json.containsKey("pp")) {
      probabilities = json['pp'];
    }
  }
}