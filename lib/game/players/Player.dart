import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';
import 'package:pokegrid/game/players/PlayerBase.dart';

class Player extends PlayerBase{

  Player(int level, List<PokemonContainer> pokes) : super(curLevel: level, pokelist: pokes);

  @override
  MoveContainer? getMove() {
    //El movimiento es elegido por la pagina del combato que es controlado por el usuario
    return curMove;
  }

  @override
  String changePokemon() {
    int prevPoke = curPokemon;
    curPokemon = nextPokemon;
    return "El jugador 1, cambió de ${pokelist[prevPoke].name} a ${pokelist[curPokemon].name}";
  }

}