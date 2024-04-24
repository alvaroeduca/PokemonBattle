class PokeSpeciesData {
  int? baseHappiness;
  int? captureRate;
  EvolutionChain? evolutionChain;
  List<FlavorTextEntries>? flavorTextEntries;
  List<Null>? formDescriptions;
  bool? formsSwitchable;
  List<Genera>? genera;
  int? genderRate;
  bool? hasGenderDifferences;
  int? hatchCounter;
  int? id;
  bool? isBaby;
  bool? isLegendary;
  bool? isMythical;
  String? name;
  List<Names>? names;
  int? order;
  List<PalParkEncounters>? palParkEncounters;
  List<PokedexNumbers>? pokedexNumbers;
  List<Varieties>? varieties;

  PokeSpeciesData(
      {this.baseHappiness,
        this.genera,
        this.captureRate,
        this.evolutionChain,
        this.flavorTextEntries,
        this.formDescriptions,
        this.formsSwitchable,
        this.genderRate,
        this.hasGenderDifferences,
        this.hatchCounter,
        this.id,
        this.isBaby,
        this.isLegendary,
        this.isMythical,
        this.name,
        this.names,
        this.order,
        this.palParkEncounters,
        this.pokedexNumbers,
        this.varieties
        });

  PokeSpeciesData.fromJson(Map<String, dynamic> json) {
    baseHappiness = json['base_happiness'];
    captureRate = json['capture_rate'];
    if(json.containsKey('evolution_chain')) {
      evolutionChain =  EvolutionChain.fromJson(json['evolution_chain']);
    }
    if (json['flavor_text_entries'] != null) {
      flavorTextEntries = <FlavorTextEntries>[];
      json['flavor_text_entries'].forEach((v) {
        flavorTextEntries!.add(new FlavorTextEntries.fromJson(v));
      });
    }
    if (json['genera'] != null) {
      genera = <Genera>[];
      json['genera'].forEach((v) {
        genera!.add(new Genera.fromJson(v));
      });
    }
    formsSwitchable = json['forms_switchable'];
    genderRate = json['gender_rate'];
    hasGenderDifferences = json['has_gender_differences'];
    hatchCounter = json['hatch_counter'];
    id = json['id'];
    isBaby = json['is_baby'];
    isLegendary = json['is_legendary'];
    isMythical = json['is_mythical'];
    name = json['name'];
    if (json['names'] != null) {
      names = <Names>[];
      json['names'].forEach((v) {
        names!.add(new Names.fromJson(v));
      });
    }
    order = json['order'];
    if (json['pal_park_encounters'] != null) {
      palParkEncounters = <PalParkEncounters>[];
      json['pal_park_encounters'].forEach((v) {
        palParkEncounters!.add(new PalParkEncounters.fromJson(v));
      });
    }
    if (json['pokedex_numbers'] != null) {
      pokedexNumbers = <PokedexNumbers>[];
      json['pokedex_numbers'].forEach((v) {
        pokedexNumbers!.add(new PokedexNumbers.fromJson(v));
      });
      if(json.containsKey('varieties')) {
        varieties = [];
        json['varieties'].forEach((v) {
          varieties!.add(Varieties.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_happiness'] = this.baseHappiness;
    data['capture_rate'] = this.captureRate;
    /*
    if (this.evolutionChain != null) {
      data['evolution_chain'] = this.evolutionChain!.toJson();
    }

     */
    if (this.genera != null) {
      data['genera'] = this.genera!.map((v) => v.toJson()).toList();
    }
    if (this.flavorTextEntries != null) {
      data['flavor_text_entries'] =
          this.flavorTextEntries!.map((v) => v.toJson()).toList();
    }
    data['forms_switchable'] = this.formsSwitchable;
    data['gender_rate'] = this.genderRate;
    data['has_gender_differences'] = this.hasGenderDifferences;
    data['hatch_counter'] = this.hatchCounter;
    data['id'] = this.id;
    data['is_baby'] = this.isBaby;
    data['is_legendary'] = this.isLegendary;
    data['is_mythical'] = this.isMythical;
    data['name'] = this.name;
    if (this.names != null) {
      data['names'] = this.names!.map((v) => v.toJson()).toList();
    }
    data['order'] = this.order;
    if (this.palParkEncounters != null) {
      data['pal_park_encounters'] =
          this.palParkEncounters!.map((v) => v.toJson()).toList();
    }
    if (this.pokedexNumbers != null) {
      data['pokedex_numbers'] =
          this.pokedexNumbers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EvolutionChain {
  String? url;

  EvolutionChain({this.url});

  EvolutionChain.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}

class FlavorTextEntries {
  String? flavorText;

  FlavorTextEntries({this.flavorText});

  FlavorTextEntries.fromJson(Map<String, dynamic> json) {
    flavorText = json['flavor_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flavor_text'] = this.flavorText;
    return data;
  }
}

class Genera {
  String? genus;

  Genera({this.genus});

  Genera.fromJson(Map<String, dynamic> json) {
    genus = json['genus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genus'] = this.genus;
    return data;
  }
}

class Names {
  String? name;

  Names({this.name});

  Names.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class PalParkEncounters {
  int? baseScore;
  int? rate;

  PalParkEncounters({this.baseScore, this.rate});

  PalParkEncounters.fromJson(Map<String, dynamic> json) {
    baseScore = json['base_score'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_score'] = this.baseScore;
    data['rate'] = this.rate;
    return data;
  }
}

class PokedexNumbers {
  int? entryNumber;

  PokedexNumbers({this.entryNumber});

  PokedexNumbers.fromJson(Map<String, dynamic> json) {
    entryNumber = json['entry_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entry_number'] = this.entryNumber;
    return data;
  }
}

class Varieties {
  bool? isDefault;
  PokeMonVariety? pokevariety;

  Varieties({this.isDefault, this.pokevariety});

  Varieties.fromJson(Map<String, dynamic> json) {
    isDefault = json['is_default'];
    if(json.containsKey('pokemon')) {
      pokevariety = PokeMonVariety.fromJson(json['pokemon']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_default'] = this.isDefault;
    return data;
  }
}

class PokeMonVariety {
  String? name;
  String? url;
  
  PokeMonVariety({this.name, this.url});

  PokeMonVariety.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('name')) {
      name = json['name'];
    }
    if(json.containsKey('url')) {
      url = json['url'];
    }
  }
}