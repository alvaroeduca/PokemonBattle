

import 'dart:math';

import 'package:pokegrid/PokeBattlePage.dart';
import 'package:pokegrid/data/mainContainers/HealthObjectContainer.dart';
import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';
import 'package:pokegrid/game/players/Cpu.dart';
import 'package:pokegrid/game/players/Player.dart';
import 'package:pokegrid/game/players/PlayerBase.dart';
enum States { choose, combat, changePokemon,asktoTryAgain, chooseItem, useItem, win }
class BattleController {
  List<PlayerBase> players = [];
  States curState = States.choose;
  Function onPokeAttack;
  Function onConbatFinished;
  Function onPokeChanged;
  Function onPokeChangeFinished;
  Function onUseItem;
  Function onUseItemFinished;

  BattleController(List<PokemonContainer> pokes1, List<PokemonContainer> pokes2, this.onPokeAttack, this.onConbatFinished, this.onPokeChanged, this.onPokeChangeFinished, this.onUseItem, this.onUseItemFinished) {
    int level1 = 1+Random().nextInt(101-1);
    int level2 = min(100,level1+(2+Random().nextInt(4-2)));
    players.add(Cpu(level1, pokes1));
    players.add(Player(level2, pokes2));
  }

  void combat() async {
    MoveContainer? foundMove;
    bool exit = false;
    int index = 1;
    curState = States.combat;
    String message = "";

    while(!exit) {
      //Si ese objeto es del jugador se introducirá se usará solamente el elemento usado por el objeto del jugador
      //de lo contrario será elegido aleatoriamente por la maquina.
      foundMove = players[index].getMove();
      if(Random().nextInt(100) > foundMove!.probabilities) {
        message = players[index].getMessage();
        attack(foundMove, players[index == 0 ? 1 : 0]);
      } else {
        message = "${players[index].getMessage()} pero falla";
      }
      onPokeAttack(message);
      await Future.delayed(const Duration(seconds:  2));
      //Si unos de los pokemons está muerto, se termina el bucle.
      if(players[index == 0 ? 1 : 0].numPokeVivos() < 1) {
        players[index].isWinner = true;
        exit = true;
      } else {
        index--;
        if(index < 0) {
          exit = true;
        } else {
          await changePokemon(players[0]);
        }
      }
    }
    onConbatFinished(players);
  }

  Future<void> changePokemon(PlayerBase player) async {
    States prevState = curState;
    String message = player.changePokemon();
    //Comprueba si anteriormente si el estado de la batalla estaba en espera o en combate.
    if(message.isNotEmpty) {
      curState = States.changePokemon;
      onPokeChanged(message);
      await Future.delayed(const Duration(seconds:  2));
      if(prevState != States.combat) {
        curState = States.choose;
      } else {
        curState = States.combat;
      }
      onPokeChangeFinished();
    }
  }

  void cure() async {
    curState = States.useItem;
    onUseItem(players[1].increaseHP());
    await Future.delayed(const Duration(seconds:  2));
    onUseItemFinished(players[1].curObj);
    curState = States.choose;
    players[1].curObj = null;
  }

  void attack(MoveContainer move, PlayerBase player) async {
    player.reduceHP(move);
    await Future.delayed(const Duration(seconds:  2));
  }

}