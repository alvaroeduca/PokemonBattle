class GenreData {
  int? id;
  String? name;
  List<PokemonSpeciesDetails>? pokemonSpeciesDetails;

  GenreData(
      {this.id,
        this.name,
        this.pokemonSpeciesDetails,});

  GenreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['pokemon_species_details'] != null) {
      pokemonSpeciesDetails = <PokemonSpeciesDetails>[];
      json['pokemon_species_details'].forEach((v) {
        pokemonSpeciesDetails!.add(new PokemonSpeciesDetails.fromJson(v));
      });
    }
    }
  }

class PokemonSpeciesDetails {
  PokemonSpecies? pokemonSpecies;
  int? rate;

  PokemonSpeciesDetails({this.pokemonSpecies, this.rate});

  PokemonSpeciesDetails.fromJson(Map<String, dynamic> json) {
    pokemonSpecies = json['pokemon_species'] != null
        ? new PokemonSpecies.fromJson(json['pokemon_species'])
        : null;
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pokemonSpecies != null) {
      data['pokemon_species'] = this.pokemonSpecies!.toJson();
    }
    data['rate'] = this.rate;
    return data;
  }
}

class PokemonSpecies {
  String? name;
  String? url;

  PokemonSpecies({this.name, this.url});

  PokemonSpecies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}