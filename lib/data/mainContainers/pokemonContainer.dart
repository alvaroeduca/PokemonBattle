import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokegrid/data/mainContainers/SexData.dart';
import 'package:pokegrid/data/mainContainers/mainStats.dart';
import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/othersDatas.dart';

class PokemonContainer {
  String name;
  String artwork;
  int id;
  MainStats stats;
  OtherDatas otherdata;
  PokemonContainer({required this.name, required this.artwork, required this.id, required this.stats, required this.otherdata});

  bool isWeakTo(MoveContainer moveContainer) {

    return otherdata.isWeakTo(moveContainer);
  }

  Color? getFirstTypeColor() {
    return otherdata.getFirstTypeColor();
  }

  MoveContainer getMove(int index) {
    return otherdata.moveNames[index];
  }

  MoveContainer getRandomMove() {
    return otherdata.getRandomMove();
  }

  List<SexData> getGenders() {
    return otherdata.sexos;
  }
}