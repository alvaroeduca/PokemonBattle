class HealthObjectContainer{
  //En Pokemon hay tres tipos de pociones, potion que recupera 20 hp, el super 60hp y el hyper 120 hp
  static final Map<String, int> _potions = {
    "potion" : 20,
    "super-potion" : 50,
    "hyper-potion" : 200,
  };
  String name = "";
  String sprite = "";
  String description = "";
  int hpAmount = 0;

  HealthObjectContainer({required this.name, required this.sprite, required this.description}){
    hpAmount = _potions[name]!;
  }
}