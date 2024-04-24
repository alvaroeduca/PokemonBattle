import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokegrid/data/mainContainers/pokemonContainer.dart';

class PokeInfoPAge extends StatefulWidget {
  const PokeInfoPAge({super.key, required this.index, required this.containers});
  final List<PokemonContainer?> containers;
  final int index;

  @override
  State<PokeInfoPAge> createState() => _PokeInfoPAgeState();
}

class _PokeInfoPAgeState extends State<PokeInfoPAge> {

  int curIndex = 0;
  int pokeAnterior = 0;
  int pokePosterior = 0;
  String? curDescp;

  @override
  void initState() {
    curIndex = widget.index;
    curDescp = widget.containers[curIndex]!.otherdata.description;
    determinarIndice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Info"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 72,
                    child: ElevatedButton(
                      onPressed: () {
                        if(curIndex-1 == -1)       {
                          curIndex = widget.containers.length-1;
                        } else {
                          curIndex--;
                        }
                        determinarIndice();
                        setState(() {

                        });
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: const ContinuousRectangleBorder()
                    ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back, size: 24, color: Colors.white,),
                          const SizedBox(
                            width: 8,
                          ),
                          Text("#${widget.containers[pokeAnterior]!.id}", style: const TextStyle(fontSize: 24, color: Colors.white),),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(widget.containers[pokeAnterior]!.name, style: const TextStyle(fontSize: 24, color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: SizedBox(
                    height: 72,
                    child: ElevatedButton(
                      onPressed: () {
                        if(curIndex+1 == widget.containers.length)       {
                          curIndex = 0;
                        } else {
                          curIndex++;
                        }
                        determinarIndice();
                        setState(() {

                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: const ContinuousRectangleBorder()
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.containers[pokePosterior]!.name, style: const TextStyle(fontSize: 24, color: Colors.white),),
                          const SizedBox(
                            width: 8,
                          ),
                          Text("#${widget.containers[pokePosterior]!.id}", style: const TextStyle(fontSize: 24, color: Colors.white),),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(Icons.arrow_forward, size: 24, color: Colors.white,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.containers[curIndex]!.name, style: const TextStyle(fontSize: 26),),
                  const SizedBox(width: 12,),
                  Visibility(
                    visible: widget.containers[curIndex]!.otherdata.tieneMegaEvolucion,
                      child: Text("(Tiene megaevolución)", style: const TextStyle(fontSize: 24,color: Colors.grey)))
                ],
              ),
            ),
            SizedBox(
              height: 1200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  leftBlock(),
                  const SizedBox(width: 32,),
                  rightBlock(),
                ],
              ),
            )
          ],

        ),
      ),
    );
  }

  Widget leftBlock() {
    return Expanded(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Container(color: Colors.grey[200], child: Image.network(widget.containers[curIndex]!.artwork),)),
          const SizedBox(
            height: 20,
          ),
          Expanded(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Puntos de Base", style: TextStyle(fontSize: 16),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          generarBarra("PS", widget.containers[curIndex]!.stats.hp),
                          generarBarra("Ataque", widget.containers[curIndex]!.stats.hp),
                          generarBarra("Defensa", widget.containers[curIndex]!.stats.hp),
                          generarBarra("AE", widget.containers[curIndex]!.stats.sa),
                          generarBarra("DE", widget.containers[curIndex]!.stats.sd),
                          generarBarra("Velocidad", widget.containers[curIndex]!.stats.speed),
                        ],
                      ),
                    )
                  ],
                )),
              ),
            ],
          )),
        ],
                ));
  }

  Widget generarBarra(String s, int num) {
    double result = (8 * (num/255));
    List<Widget> bar = List.generate(10, (index) {
      if(index < 9) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: Container(
              color: index > result ? Colors.white : Colors.blue,
              width: 102,
              height: 10,
            ),
          ),
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(s)
        ],
      );
    });
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: bar
      ),
    );
  }

  Widget rightBlock() {
    return Expanded(child: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(curDescp!, style: TextStyle(fontSize: 22,), textAlign: TextAlign.start,),
          SizedBox(
            height: 102,
            child: Row(
              children: [
                Text("Versions: ",style: TextStyle(fontSize: 18,)),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      curDescp = widget.containers[curIndex]?.otherdata.description;
                    });
                  },
                    child: Icon(Icons.catching_pokemon, color: Colors.blue, size: 32,)),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    if(widget.containers[curIndex]!.otherdata.description2.isNotEmpty) {
                      setState(() {
                        curDescp = widget.containers[curIndex]?.otherdata.description2;
                      });
                    }
                  },
                    child: const Icon(Icons.catching_pokemon, color: Colors.pinkAccent, size: 32,))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.lightBlue,
              ),
              padding: const EdgeInsets.all(12),
              height: 322,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Height", style: TextStyle(color: Colors.white, fontSize: 22),),
                            const SizedBox(height: 12,),
                            Text("${widget.containers[curIndex]!.otherdata.height}", style: const TextStyle(fontSize: 21),)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Weight", style: TextStyle(color: Colors.white, fontSize: 22),),
                            const SizedBox(height: 12,),
                            Text("${widget.containers[curIndex]!.otherdata.weight}", style: TextStyle(fontSize: 21),)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Sex", style: TextStyle(color: Colors.white, fontSize: 22),),
                            const SizedBox(height: 12,),
                            Row(
                              children:widget.containers[curIndex]!.otherdata.sexos.isEmpty ? [] :
                              List.generate(widget.containers[curIndex]!.otherdata.sexos.length, (index) {
                                return Icon(widget.containers[curIndex]!.otherdata.sexos[index].icon);
                              })
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Category", style: TextStyle(color: Colors.white, fontSize: 22),),
                            const SizedBox(height: 12,),
                            Text(widget.containers[curIndex]!.otherdata.categ, style: const TextStyle(fontSize: 21),)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Abilities", style: TextStyle(color: Colors.white, fontSize: 22),),
                            const SizedBox(height: 12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(widget.containers[curIndex]!.otherdata.abilitiesName.length, (index) {
                                return Row(
                                  children: [
                                    Text(widget.containers[curIndex]!.otherdata.abilitiesName[index].name, style: TextStyle(fontSize: 21)),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                        child: Icon(Icons.info_outline),
                                    onTap: () {
                                          showDialog(context: context,
                                              builder: (BuildContext contect) {
                                            return AlertDialog(
                                              title: Text(widget.containers[curIndex]!.otherdata.abilitiesName[index].name),
                                              content: Text(widget.containers[curIndex]!.otherdata.abilitiesName[index].desc),
                                            );
                                              });
                                    },),
                                  ],
                                );
                              })
                            )
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16,),
          const Text("Type", style: TextStyle(fontSize: 24),),
          const SizedBox(height: 16,),
          Row(
            children: List.generate(widget.containers[curIndex]!.otherdata.tipos.length, (index) =>
              Container(
                decoration: BoxDecoration(
                  color: widget.containers[curIndex]!.otherdata.tipos[index].color,
                  borderRadius: BorderRadius.circular(4)
                ),
                width: 128,
                height: 32,
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
                child: Center(
                  child: Text(widget.containers[curIndex]!.otherdata.tipos[index].typename as String,
                    style: const TextStyle(
                        fontSize: 16),),
                ),
              )),
          ),
          const SizedBox(height: 16,),
          const Text("Weakness", style: TextStyle(fontSize: 24),),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(widget.containers[curIndex]!.otherdata.debilidades.length, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      color: widget.containers[curIndex]!.otherdata.debilidades[index].color,
                    ),
                    height: 32,
                    child: Center(child: Text(widget.containers[curIndex]!.otherdata.debilidades[index].typename as String,
                      style: const TextStyle(fontSize: 16),))),
                ),
              );
            }),
          )
        ],
      ),
    ));
  }

  void determinarIndice() {
    pokePosterior = curIndex+1;
    pokeAnterior = curIndex-1;

    if(curIndex == 0) {
      pokeAnterior = widget.containers.length-1;
    } else if(curIndex == widget.containers.length-1) {
      pokePosterior = 0;
    }
    curDescp = widget.containers[curIndex]?.otherdata.description;
  }
}
