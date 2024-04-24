import 'dart:isolate';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokegrid/PokeBattlePage.dart';
import 'package:pokegrid/data/mainContainers/HealthObjectContainer.dart';
import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';
import 'package:pokegrid/game/BattleController.dart';
import 'package:pokegrid/game/players/PlayerBase.dart';
import 'package:collection/collection.dart';

class PokeBattlePage extends StatefulWidget {
  const PokeBattlePage({super.key, required this.pokemon1, required this.pokemon2, required this.healthObjs});

  final List<PokemonContainer>? pokemon1;
  final List<PokemonContainer?> pokemon2;
  final List<HealthObjectContainer> healthObjs;

  @override
  State<PokeBattlePage> createState() => PokeBattlePageState();
}

class PokeBattlePageState extends State<PokeBattlePage> {

  List<List<Widget>> estadosBotones = [];
  List<List<Widget>> estadosTexto = [];
  int curState = 0;
  BattleController? controller;
  String attackMessage = "";
  String winnerMessage = "";
  String changeMessage = "";
  String cureMessage = "";
  bool canExit = false;
  List<HealthObjectContainer> healthObjsBattle = [];
  int allObjs = 0;

  @override
  void initState() {
    for (var hpObj in widget.healthObjs) {
      healthObjsBattle.add(hpObj);
    }
    allObjs = healthObjsBattle.length;
    controller = BattleController(widget.pokemon2 as List<PokemonContainer>,  widget.pokemon1 as List<PokemonContainer>, setAttackMessage, combatFinished, setChangeMessage, setStateafterChanged, setCureMessage, cleanCureMessage);
    generarTextos();
    generarBotones();
    super.initState();
  }

  void changeState(int num) {
    setState(() {
      curState = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<States, List<Widget>>? rowState = generateMap();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Battle"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: canExit,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                generarFila(controller!.players[0], true),
                generarFila(controller!.players[1], false),
              ],
            ),
          ),
          Expanded(
            flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: rowState![controller?.curState] as List<Widget>
              ),
          )
        ],
      ),
    );
  }

  Widget generarFila(PlayerBase player, bool reversed) {
    PokemonContainer? pokemon = player.getCurrentPoke();

    List<Widget> lista = [
      Expanded(child: Image.network(pokemon!.artwork)),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: reversed ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: reversed ? 72: 0,
                  bottom: reversed ? 0: 72,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black,
                  )
                ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: reversed ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(pokemon.name, style: const TextStyle(fontSize: 32),),
                              player.getCurrentSex() == null ? const Text("") : Icon(player.getCurrentSex()?.icon, color: player.getCurrentSex()?.color, size: 24,)
                            ],
                          ),
                          Text("lvl ${player.curLevel}", style: const TextStyle(fontSize: 24),),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 72),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  color: player.getCurHP() < pokemon.stats.hp/2 ? Colors.yellow : Colors.green,
                                ),
                              child: Center(child: Text("${player.getCurHP()}/${pokemon.stats.hp} HP", style: const TextStyle(fontSize: 22),)),),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      )
    ];

    if(reversed) {
      lista = lista.reversed.toList();
    }

    return Expanded(
      child: Row(
        children: lista
      ),
    );
  }

  void generarBotones() {
    estadosBotones = [
      [
        //Main Menu
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      changeState(1);
                    },
                    child: const Text("Luchar", style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        controller?.curState = States.chooseItem;
                        curState = 4;
                      });
                    },
                    child: const Text("Bolsa", style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      changeState(2);
                    },
                    child: Text("Pokemon", style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Huir", style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
            ],
          ),
        ),
      ],
      //Choosing attack
      [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        curState = 0;
                      });
                    },
                    child: const Text("Atras", style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: controller!.players[1].obtainMove(0).moveType?.color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      triggerCombat(controller!.players[1].obtainMove(0));
                    },
                    child: Text(controller!.players[1].obtainMove(0).name, style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: controller?.players[1].obtainMove(1).moveType?.color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      triggerCombat(controller!.players[1].obtainMove(1));
                    },
                    child: Text(controller!.players[1].obtainMove(1).name, style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: controller!.players[1].obtainMove(2).getColor(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      triggerCombat(controller!.players[1].obtainMove(2));
                    },
                    child: Text(controller!.players[1].obtainMove(2).name, style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: controller!.players[1].obtainMove(3).getColor(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      triggerCombat(controller!.players[1].obtainMove(3));
                    },
                    child: Text(controller!.players[1].obtainMove(3).name, style: const TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
            ],
          ),
        )
      ],
      //Choosing Pokemon
      [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        if(controller?.curState == States.choose) {
                          curState = 0;
                        } else if(controller?.curState == States.asktoTryAgain) {
                          curState = 3;
                        }
                      });
                    },
                    child: const Text("Atras", style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: controller?.players[1].getPokeHPByIndex(0) == 0 ? Colors.grey :
                        controller!.players[1].getCurrentPokeColorByIndex(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      changePokemon(0);
                    },
                    child: Text(controller!.players[1].getPokeNameByIndex(0), style: const TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:  controller?.players[1].getPokeHPByIndex(1) == 0 ? Colors.grey :
                        controller!.players[1].getCurrentPokeColorByIndex(1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      changePokemon(1);
                    },
                    child: Text(controller!.players[1].getPokeNameByIndex(1), style: const TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: controller?.players[1].getPokeHPByIndex(2) == 0 ?
                        Colors.grey : controller!.players[1].getCurrentPokeColorByIndex(2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      changePokemon(2);
                    },
                    child: Text(controller!.players[1].getPokeNameByIndex(2), style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:  controller?.players[1].getPokeHPByIndex(3) == 0 ?
                        Colors.grey : controller!.players[1].getCurrentPokeColorByIndex(3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      changePokemon(3);
                    },
                    child: Text(controller!.players[1].getPokeNameByIndex(3), style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
            ],
          ),
        ),
      ],
      [
        //Try again menu
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
              onPressed: () {
                //Muestrta los botones aquellos pokemon que fueron derrotados en gris.
                generarBotones();
                changeState(2);
              },
              child: const Text("Pokemon", style: TextStyle(fontSize: 32, color: Colors.white),),),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Huir", style: TextStyle(fontSize: 32, color: Colors.white),),),
          ),
        ),
      ],
      [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        controller?.curState = States.choose;
                        curState = 0;
                      });
                    },
                    child: const Text("Atras", style: TextStyle(fontSize: 32, color: Colors.white),),),
                ),
              ),
              Expanded(
                child: healthObjsBattle.isNotEmpty ? ListView.builder(itemCount: healthObjsBattle.length, itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () => triggerObjectUse(healthObjsBattle[index]),
                    leading: Image.network(healthObjsBattle[index].sprite),
                    title: Text(healthObjsBattle[index].name),
                  subtitle: Text(healthObjsBattle[index].description),);
                },) :
                const Center(child: Text("Vacio", style: TextStyle(fontSize: 42),)),
              )
            ],
          ),
        ),
      ]
    ];
  }
  void generarTextos() {
    estadosTexto = [
      [
        Text("¿Que hará ${controller!.players[1].getCurrentPoke().name}?", style: const TextStyle(fontSize: 42),),
      ],
      [
        Text("¿Que ataque elegirá ${controller!.players[1].getCurrentPoke().name}?", style: const TextStyle(fontSize: 42),),
      ],
      [
        const Text("¿Que pokemon vas a elegir?", style: TextStyle(fontSize: 42),),
      ],
      [
        const Text("¿Deseas cambiar de pokemon?", style: TextStyle(fontSize: 42),),
      ],
      [
        const Text("¿Que objeto vas a elegir?", style: TextStyle(fontSize: 42),),
      ],
    ];
  }

  void triggerCombat(MoveContainer move) {
    //El usuario siempre elegira movimiento para el objeto jugable
    controller?.players[1].curMove = move;
    //Reinicia los estados para la ventana de selección.
    curState = 0;
    controller?.combat();
  }

  void triggerObjectUse(HealthObjectContainer hpObj) {
    //El usuario siempre elegira un objeto para el objeto jugable
    controller?.players[1].curObj = hpObj;
    //Reinicia los estados para la ventana de selección.
    curState = 0;
    controller?.cure();
  }

  void setCureMessage(String message) {
    setState(() {
      cureMessage = message;
    });
  }

  void cleanCureMessage(HealthObjectContainer obj) {
    setState(() {
      healthObjsBattle.remove(obj);
      //Previene un out of range error de la listview.
      generarBotones();
      cureMessage = "";
    });
  }

  void setAttackMessage(String message) {
    setState(() {
      attackMessage = message;
    });
  }
  void setChangeMessage(String message) {

    setState(() {
      changeMessage = message;
    });
  }

  void setStateafterChanged() {
    setState(() {
      //Previene errores al cambiar de pokemon
      generarTextos();
      generarBotones();
      attackMessage = "";
    });
  }


  void combatFinished(List<PlayerBase> players) {
    PlayerBase? foundWinner;
    foundWinner = players.firstWhereOrNull((element) => element.isWinner);
    PokemonContainer? foundPokemon;
    setState(() {
      if(foundWinner == null) {
        if(players[1].getCurHP() == 0) {
          controller?.curState = States.asktoTryAgain;
          curState = 3;
        } else {
          controller?.curState = States.choose;
        }
      } else {
        canExit = true;
        controller?.curState = States.win;
        foundPokemon = foundWinner.getCurrentPoke();
        winnerMessage = "Enhorabuena ${foundPokemon?.name} ha ganado";
      }
    });

  }

  Map<States, List<Widget>>? generateMap() {
    return {
      States.choose : [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: estadosTexto[curState],
              ),
            )
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: estadosBotones[curState]
            ),
          ),
        ),
      ],
      States.combat: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(attackMessage, style: const TextStyle(fontSize: 42))),
            ],
          ),
        )
      ],
      States.changePokemon: [
        Expanded(child: Center(child: Text(changeMessage, style: const TextStyle(fontSize: 42)))),
      ],
      States.asktoTryAgain: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: estadosTexto[curState],
              ),
            )
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: estadosBotones[curState]
            ),
          ),
        ),
      ],
      States.win: [
        Expanded(child: Center(child: Text(winnerMessage, style: const TextStyle(fontSize: 42)))),
      ],
      States.chooseItem: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: estadosTexto[curState],
              ),
            )
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: estadosBotones[curState]
            ),
          ),
        ),
      ],
      States.useItem: [
        Expanded(child: Center(child: Text(cureMessage, style: const TextStyle(fontSize: 42)))),
      ],
    };
  }

  void changePokemon(int number) {
    //Solamente cambiará de pokemon si no es el mismo y si el pokemon elegido no esta muerto.
    if(number != controller?.players[1].curPokemon && controller?.players[1].getPokeHPByIndex(number) != 0) {
      curState = 0;
      controller?.players[1].nextPokemon = number;
      controller?.changePokemon(controller!.players[1]);
    }
  }
}
