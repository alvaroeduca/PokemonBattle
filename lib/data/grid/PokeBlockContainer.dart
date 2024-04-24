import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';

class PokeBlockContainer {
  PokemonContainer? pokemon;
  bool choosen = false;

  PokeBlockContainer({required this.pokemon});

  int getID() {
    return pokemon?.id as int;
  }

  String getName() {
    return pokemon?.name as String;
  }
}