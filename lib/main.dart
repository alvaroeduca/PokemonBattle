import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokegrid/PokeBattlePage.dart';
import 'package:pokegrid/data/Abilities.dart';
import 'package:pokegrid/data/HealthObjectData.dart';
import 'package:pokegrid/data/OtherObjectData.dart';
import 'package:pokegrid/data/genreData.dart';
import 'package:pokegrid/data/grid/PokeBlockContainer.dart';
import 'package:pokegrid/data/mainContainers/HealthObjectContainer.dart';
import 'package:pokegrid/data/mainContainers/SexData.dart';
import 'package:pokegrid/data/mainContainers/abilityContainer.dart';
import 'package:pokegrid/data/mainContainers/mainStats.dart';
import 'package:pokegrid/data/mainContainers/moveContainer.dart';
import 'package:pokegrid/data/mainContainers/othersDatas.dart';
import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';
import 'package:pokegrid/data/mainContainers/typeContainer.dart';
import 'package:pokegrid/data/mainPokeData.dart';
import 'package:pokegrid/data/otherPokeData.dart';
import 'package:pokegrid/data/pokeSpeciesData.dart';
import 'package:http/http.dart' as http;
import 'package:pokegrid/data/typeData.dart';
import 'package:pokegrid/pokeInfopage.dart';
import 'package:collection/collection.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<PokemonContainer?> pokemons = [];
  List<PokeBlockContainer?> pokemonsContainers = [];
  List<PokeBlockContainer?> selectedPokemons = [];
  List<HealthObjectContainer> hpObjs = [];
  int curIndex = 12;
  List<String> order = ['Numero inferior', 'Numero Superior', 'A-Z', 'Z-A'];
  String curOrder = "";
  Future<List<PokemonContainer?>>? future;

  @override
  void initState() {
    future = loadPokemons();
    curOrder = order.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<PokemonContainer?>>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<List<PokemonContainer?>> snapshot) {
          if(snapshot.hasData) {
            pokemons = snapshot.data!;
            //Crea una copia para asi garantizar el orden de los pokemons si el usuario pasa a la siguiente pantalla
            if(pokemonsContainers.isEmpty) {
              //Previene que la lista vuelva a ser añadida.
              for (var element in pokemons) {
                pokemonsContainers.add(PokeBlockContainer(pokemon: element));
              }
            }
            return generateMainPage();
          } else {
            if(snapshot.hasError) {
              const Center(child: Text("No se pudo cargar los datos"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
          return Container();
        },
      )
    );
  }

  Widget generateContainer(PokemonContainer pokemon, int index) {
    return GestureDetector(
      onTap: () {
        navegar(pokemons.indexOf(pokemon));
      },
      onDoubleTap: () {
        if(!pokemonsContainers[index]!.choosen) {
          selectedPokemons.add((pokemonsContainers[index]));
          if(selectedPokemons.length == 2) {
            navegarABatalla(selectedPokemons[1]?.pokemon, selectedPokemons[0]?.pokemon);
            setState(() {
              for (var element in selectedPokemons) {
                element?.choosen = false;
              }
              selectedPokemons.clear();
            });
          } else {
            setState(() {
              pokemonsContainers[index]!.choosen = true;
            });
          }
        } else {
          selectedPokemons.remove(pokemonsContainers[index]);
        setState(() {
        pokemonsContainers[index]!.choosen = false;
        });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: pokemonsContainers[index]!.choosen ? Colors.red : Colors.white
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: Image.network(pokemon.artwork),)),
            Expanded(child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                      left: 12,
                      child: Text("#${pokemon.id}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)),
                  Positioned(
                    left: 12,
                      top: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pokemon.name, style: const TextStyle(fontSize: 26),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(pokemon.otherdata.tipos.length, (index) =>
                                Container(
                                  decoration: BoxDecoration(
                                    color: pokemon.otherdata.tipos[index].color,
                                    borderRadius: BorderRadius.circular(4)
                                  ),
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
                                  child: Center(
                                    child: Text(pokemon.otherdata.tipos[index].typename as String,
                                      style: const TextStyle(
                                          fontSize: 16),),
                                  ),
                                )),
                          )
                        ],
                      )
                  ),
                ],
              ),
             )
            ),
          ],
        ),
      ),
    );
  }

  Widget generateMainPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 500,
                        height: 48,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)
                                ),
                              backgroundColor: Colors.blue
                            ),
                            onPressed: changeOrder,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.catching_pokemon, color: Colors.white,),
                                SizedBox(width: 12,),
                                Text("¡Sorprendeme!", style: TextStyle(fontSize: 24, color: Colors.white),),
                              ],
                            )),
                      ),
                      Row(
                        children: [
                          const Text("Ordenado por", style: TextStyle(fontSize: 24),),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: 400,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.catching_pokemon),
                                fillColor: Colors.black26,
                                filled: true
                              ),
                              isExpanded: true,
                              value: curOrder,
                              items: order.map((e) {
                              return DropdownMenuItem(value: e, child: Text(e),);
                            }).toList(), onChanged: (String? value) {
                                setState(() {
                                  curOrder = value!;
                                  if(curOrder == "Numero inferior") {
                                    pokemonsContainers.sort((a, b) => a!.getID().compareTo(b!.getID()));
                                  } else if(curOrder == "Numero Superior") {
                                    pokemonsContainers.sort((a, b) => b!.getID().compareTo(a!.getID()));
                                  } else if(curOrder == "A-Z") {
                                    pokemonsContainers.sort((a, b) => a!.getName().compareTo(b!.getName()));
                                  } else {
                                    pokemonsContainers.sort((a, b) => b!.getName().compareTo(a!.getName()));
                                  }
                                });
                            },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1000,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10
                ),
                itemCount: curIndex,
                itemBuilder: (BuildContext context, int index) {
                  return generateContainer(pokemonsContainers[index]!.pokemon as PokemonContainer, index);
              },)
            ),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 64,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)
                            ),
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: (){
                          setState(() {
                            curIndex = min(curIndex+4, pokemonsContainers.length);
                          });
                        },
                        child: const Text("Load more pokemons", style: TextStyle(fontSize: 24, color: Colors.white),)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeOrder() {
    setState(() {
      pokemonsContainers.shuffle();
    });
}

  Future<List<PokemonContainer?>>loadPokemons() async {
    List<PokemonContainer?> pokemons = [];
    List<TypeContainer> foundTypes = [];
    List<AbilityContainer> abilities = [];
    List<TypeContainer> weakness = [];
    List<GenreData> genders = [];
    List<SexData> sexs = [];
    List<MoveContainer> moveNames = [];
    AbilitiesType abs = AbilitiesType();
    bool hasMega = false;
    String link = "https://pokeapi.co/api/v2/pokemon?limit=501&offset=0";//"https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0";
    String healthobjectsLink = "https://pokeapi.co/api/v2/item-category/27/";
    OtherPokeData? otherPokeData;
    PokeSpeciesData speciesData = PokeSpeciesData();
    Typedata typedata = Typedata();
    Uri url = Uri.parse(link);
    var response = await http.get(url);
    //Extraemos los datos principales de los pokemons
    MainPokeData pokeData = MainPokeData.fromJson(jsonDecode(response.body));
    url = Uri.parse(healthobjectsLink);
    response = await http.get(url);
    //Extraemos los datos principales de los objetos
    HealthObjectData healthobjs = HealthObjectData.fromJson(jsonDecode(response.body));
    OtherObjectData otherObjData;
    //Solamente me interesa objetos cuyo nombre son potion, super potion e hyper potion
    healthobjs.items?.removeWhere((foundItem) => foundItem.name!.startsWith("max") || !foundItem.name!.contains("potion"));
    try {
      //Cargamos cada objeto y lo guardamos
      for(var foundHPObject in healthobjs.items!) {
        url = Uri.parse(foundHPObject.url as String);
        response = await http.get(url);
        otherObjData = OtherObjectData.fromJson(jsonDecode(response.body));
        hpObjs.add(HealthObjectContainer(
            name: otherObjData.name as String,
            sprite: otherObjData.sprites?.spritesDefault as String,
            description: otherObjData.flavorTextEntries![0].text!.replaceAll("\n", " ")));
      }
      //Obtenemos todos los generos(Female y male) que contienen los nombres de todos los pokemons existentes.
      for(int i = 0; i < 2; i++){
        url = Uri.parse("https://pokeapi.co/api/v2/gender/${(i+1)}/");
        response = await http.get(url);
        genders.add(GenreData.fromJson(jsonDecode(response.body)));
      }
      for(int i = 0; i < pokeData.results!.length; i++) {
        //print(i);
        url = Uri.parse(pokeData.results![i].url as String);
        response = await http.get(url);
        otherPokeData = OtherPokeData.fromJson(jsonDecode(response.body));
        if(otherPokeData.types != null) {
          for(var foundType in otherPokeData.types!) {
            foundTypes.add(TypeContainer(typename: foundType.type!.name as String));
            url = Uri.parse("https://pokeapi.co/api/v2/type/${foundType.type!.name}");
            response = await http.get(url);
            typedata = Typedata.fromJson(jsonDecode(response.body));
            typedata.damageRelations?.doubleDamageFrom?.forEach((foundDamages) {
              weakness.add(TypeContainer(typename: foundDamages.name as String));
            });
          }
        }
        for(var foundAbility in otherPokeData.abilities!) {
          url = Uri.parse("https://pokeapi.co/api/v2//ability/${foundAbility.ability?.name}");
          response = await http.get(url);
          abs = AbilitiesType.fromJson(jsonDecode(response.body));
          abilities.add(AbilityContainer(name: foundAbility.ability!.name as String, desc: abs.effectEntries!.isEmpty ? "" :  abs.effectEntries![0].effect as String));
        }
        abs = AbilitiesType();
        otherPokeData.abilities?.forEach((foundAbility) {
          //abilities.add(foundAbility.ability?.name as String);
        });
        //Garantiza que un pokemon de un tipo no pueda ser debil por un ataque del mismo tipo
        //por ejemplo un pokemon de tipo poison no puede ser debil a los ataques
        //de tipo poison.
        for (var weaknessName in weakness) {
          if(foundTypes.contains(weaknessName)) {
            weakness.remove(weaknessName);
          }
        }
        //Buscamos si cada pokemon es masculino, femenino o ninguno en los objetos de los generos
        for (var gender in genders) {
          if(gender.name?.toLowerCase() == "female") {
            if(gender.pokemonSpeciesDetails?.firstWhereOrNull((element) => element.pokemonSpecies?.name == pokeData.results?[i].name ) != null){
              sexs.add(SexData(icon: Icons.female));
            }
          } else {
            if(gender.pokemonSpeciesDetails?.firstWhereOrNull((element) => element.pokemonSpecies?.name == pokeData.results?[i].name ) != null){
              sexs.add(SexData(icon: Icons.male));
            }
          }
        }
        url = Uri.parse(otherPokeData.species?.url as String);
        response = await http.get(url);
        speciesData = PokeSpeciesData.fromJson(jsonDecode(response.body));
        if(speciesData.varieties?.firstWhereOrNull((element) => element.pokevariety?.name?.toLowerCase().contains("mega") as bool ) != null){
          //Algunos pokemons contienen el nombre de "mega" y no tienen megaevoluciones como Meganium o Yanmega,
          //comprobamos si tiene mas variedades para prevenir falsos positivos.
          if(speciesData.varieties!.length > 1) {
            hasMega = true;

          }
        }
        for (var move in otherPokeData.moves!) {
          url = Uri.parse(move.move!.url as String);
          response = await http.get(url);
          moveNames.add(MoveContainer.fromJson(jsonDecode(response.body)));
        }
        if(moveNames.length > 4) {
         moveNames = moveNames.sublist(0, 4);
        }
        pokemons.add(PokemonContainer(
            name: pokeData.results?[i].name as String,
            artwork: otherPokeData.sprites?.other?.officialArtwork?.frontDefault as String,
            id: (i+1),
            stats: MainStats(hp: otherPokeData.stats![0].baseStat as int, attack: otherPokeData.stats![1].baseStat as int, defense: otherPokeData.stats![2].baseStat as int,sa: otherPokeData.stats![3].baseStat as int, sd: otherPokeData.stats![4].baseStat as int, speed: otherPokeData.stats![5].baseStat as int,),
            otherdata: OtherDatas(
              tipos: foundTypes,
              height: otherPokeData.height as int,
              weight: otherPokeData.weight as int,
              abilitiesName: abilities, description:
            speciesData.flavorTextEntries?[0].flavorText?.replaceAll("\n", " ") as String,
              description2: speciesData.flavorTextEntries!.length > 1 ? (speciesData.flavorTextEntries?[6].flavorText?.replaceAll("\n", " ") as String) : "",
              categ: speciesData.genera![7].genus as String,
              debilidades: weakness,
              sexos: sexs,
              tieneMegaEvolucion: hasMega,
              moveNames: moveNames,)),);
        foundTypes = [];
        abilities = [];
        weakness = [];
        moveNames = [];
        sexs = [];
        speciesData = PokeSpeciesData();
        typedata = Typedata();
        hasMega = false;
      }
    }catch(e) {
      print(e.toString());
    }
    //print("finished");
    return pokemons;
  }

  void navegarABatalla(PokemonContainer? selectedPokemon, PokemonContainer? selectedPokemon2) {

    List<PokemonContainer> randomPokesPlayer = [];
    List<PokemonContainer> randomPokesCPU = [];
    randomPokesPlayer.add(selectedPokemon2 as PokemonContainer);
    randomPokesCPU.add(selectedPokemon as PokemonContainer);

    for(int i = 0; i < 3; i++) {
      randomPokesPlayer.add(pokemons[Random().nextInt(pokemons.length)]!);
      randomPokesCPU.add(pokemons[Random().nextInt(pokemons.length)]!);
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) =>PokeBattlePage(pokemon1: randomPokesPlayer, pokemon2: randomPokesCPU, healthObjs: hpObjs)));
  }

  void navegar(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PokeInfoPAge(index: index, containers: pokemons,)));
  }
}
