import 'dart:math';

import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';
import 'package:pokegrid/game/players/PlayerBase.dart';
import 'package:collection/collection.dart';

class Cpu extends PlayerBase {

  //Usado en caso que la maquina solamente tenga un pokemon vivo, después ya no podrá cambiar mas.
  bool canLastChange = true;

  Cpu(int level, List<PokemonContainer> pokes) : super(curLevel: level, pokelist: pokes);

  @override
  MoveContainer? getMove() {
    //La cpu solamente seleccionará un movimiento al azar.
    curMove = pokelist[curPokemon].getRandomMove();
    return curMove;
  }

  @override
  String changePokemon() {
    String message = "";
    int prevPoke = curPokemon;
    //Para buscar al unico pokemon vivo si murieron el resto.
    int index = 0;

    //Cambia de pokemon si la cantidad de vida del pokemon activo reciente es
    //menor que la mitdad y si solamente tiene mas de 1 pokemon vivos
    if(getCurHP() < getCurrentPoke().stats.hp/2 && numPokeVivos() > 1) {
      //Solamente cambiará de pokemon si la cantidad de vida de la cpu es cero o un 28%.
      if(getCurHP() == 0 || Random().nextInt(100) < 28) {
        do {
          nextPokemon = Random().nextInt(pokelist.length);
          if(getPokeHPByIndex(nextPokemon) <= 0) {
            nextPokemon = curPokemon;
          }
        }while(nextPokemon == curPokemon);
        curPokemon = nextPokemon;
        message = "El jugador 2, cambió de ${pokelist[prevPoke].name} a ${pokelist[curPokemon].name}";
      }
      //La CPU solamente tiene un pokemon vivo, trata de buscar solamente al pokemon vivo.
    } else if(canLastChange && numPokeVivos() == 1) {
      //Busca al unico pokemon vivo.
      while(curHPS[index] == 0) {
        index++;
      }
      nextPokemon = index;
      canLastChange = false;
      curPokemon = nextPokemon;
      message = "El jugador 2, cambió de ${pokelist[prevPoke].name} a ${pokelist[curPokemon].name}";
    }

    return message;
  }

}