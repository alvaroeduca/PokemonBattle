import 'package:pokegrid/data/OtherObjectData.dart';
import 'package:pokegrid/data/pokeSpeciesData.dart';

class OtherObjectData {
  //List<Category> attributes;
  //Category category;
  //List<EffectEntry> effectEntries;
  List<ObjectDescription>? flavorTextEntries;
  //dynamic flingEffect;
  //int flingPower;
  int? id;
  String? name;
  //List<Name> names;
  ObjectSprites? sprites;

  OtherObjectData({
    required this.flavorTextEntries,
    required this.id,
    required this.name,
    required this.sprites,
  });

  OtherObjectData.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('flavor_text_entries')) {
      flavorTextEntries = [];
      json['flavor_text_entries'].forEach((v) {
        flavorTextEntries!.add(ObjectDescription.fromJson(v));
      });
    }
    id = json.containsKey('id') ? json['id'] as int? : null;
    name = json.containsKey('name') ? json['name'] : null;
    sprites = json.containsKey('sprites') ? ObjectSprites.fromJson(json['sprites']) : null;
  }

}

class ObjectSprites {
  String? spritesDefault;

  ObjectSprites({
    required this.spritesDefault,
  });

  ObjectSprites.fromJson(Map<String, dynamic> json) {
    spritesDefault = json.containsKey('default') ? json['default'] : null;
  }

}

class ObjectDescription {
  //Category language;
  String? text;
  //Category versionGroup;

  ObjectDescription({
    //required this.language,
    required this.text,
    //required this.versionGroup,
  });

  ObjectDescription.fromJson(Map<String, dynamic> json) {
    text = json.containsKey('text') ? json['text'] : null;
  }

}