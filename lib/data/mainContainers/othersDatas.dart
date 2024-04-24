import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:pokegrid/data/mainContainers/SexData.dart';
import 'package:pokegrid/data/mainContainers/abilityContainer.dart';
import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/typeContainer.dart';
import 'package:collection/collection.dart';

class OtherDatas {
  List<TypeContainer> tipos;
  List<TypeContainer> debilidades;
  String categ;
  List<SexData> sexos;
  bool tieneMegaEvolucion;
  String description;
  String description2;
  List<AbilityContainer> abilitiesName;
  List<MoveContainer> moveNames;
  int height;
  int weight;

  OtherDatas({
    required this.tipos,
    required this.debilidades,
    required this.categ,
    required this.sexos,
    required this.tieneMegaEvolucion, required this.description,
    required this.description2,
    required this.abilitiesName,
    required this.moveNames,
    required this.height,
    required this.weight
  });

  MoveContainer getRandomMove() {
    int lenght = moveNames.length;
    return moveNames[Random().nextInt(lenght)];
  }

  bool isWeakTo(MoveContainer moveContainer) {
    bool result = false;

    result = debilidades.firstWhereOrNull((element) => element.typename == moveContainer.moveType?.typename) != null;

    return result;
  }

  Color? getFirstTypeColor() {
    return tipos[0].color;
  }
}