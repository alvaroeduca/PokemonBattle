import 'dart:math';
import 'dart:ui';

import 'package:pokegrid/data/mainContainers/HealthObjectContainer.dart';
import 'package:pokegrid/data/mainContainers/SexData.dart';
import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';

abstract class PlayerBase {
  MoveContainer? curMove;
  bool isWinner = false;
  int curLevel = 0;
  List<SexData?> curSex = [];
  List<int> curHPS = [];
  int curPokemon = 0;
  int nextPokemon = 0;
  List<PokemonContainer> pokelist = [];
  bool stillHasPokes = true;
  HealthObjectContainer? curObj;

  PlayerBase({required this.curLevel, required this.pokelist, }) {
    for (var element in pokelist) {
      curHPS.add(element.stats.hp);
      if(element.getGenders().isNotEmpty) {
        curSex.add(obtainRandomSex(element));
      } else {
        curSex.add(null);
      }
    }
  }

  MoveContainer? getMove();

  String changePokemon();

  int numPokeVivos() {
    return curHPS.where((hpFound) => hpFound > 0).length;
  }

  PokemonContainer getCurrentPoke() {
    return pokelist[curPokemon];
  }

  String getPokeNameByIndex(int index) {
    return pokelist[index].name;
  }

  Color? getCurrentPokeColorByIndex(int index) {
    return pokelist[index].getFirstTypeColor();
  }

  SexData? getCurrentSex() {
    return curSex[curPokemon];
  }

  String getMessage() {
    return "${pokelist[curPokemon].name} usa ${curMove?.name}";
  }

  int getCurHP() {
    return curHPS[curPokemon];
  }

  int getPokeHPByIndex(int index) {
    return curHPS[index];
  }

  void reduceHP(MoveContainer move) {
    int damageAmount = move.damage;

    if(pokelist[curPokemon].isWeakTo(move)) {
      damageAmount *= 2;
    }
    curHPS[curPokemon] -= damageAmount;
    if(curHPS[curPokemon] < 0) {
      curHPS[curPokemon] = 0;
    } else if(curHPS[curPokemon] > pokelist[curPokemon].stats.hp) {
      curHPS[curPokemon] = pokelist[curPokemon]!.stats.hp;
    }
  }

  String increaseHP() {
    curHPS[curPokemon] += curObj!.hpAmount;
    if(curHPS[curPokemon] > pokelist[curPokemon].stats.hp) {
      curHPS[curPokemon] = pokelist[curPokemon].stats.hp;
    }
    return "${pokelist[curPokemon].name} recupera ${curObj!.hpAmount} PV";
  }

  MoveContainer obtainMove(int index) {
    return pokelist[curPokemon].getMove(index);
  }

  SexData? obtainRandomSex(PokemonContainer poke) {
    List<SexData>? genders = poke.getGenders();
    return genders[Random().nextInt(genders.length)];
  }
}