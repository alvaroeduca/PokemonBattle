class Typedata {
  DamageRelations? damageRelations;
  DoubleDamageFrom? generation;
  int? id;
  DoubleDamageFrom? moveDamageClass;
  String? name;
  List<Null>? pastDamageRelations;
  String? type;

  Typedata(
      {this.damageRelations,
        this.generation,
        this.id,
        this.moveDamageClass,
        this.name,
        this.pastDamageRelations,});

  Typedata.fromJson(Map<String, dynamic> json) {
    damageRelations = json['damage_relations'] != null
        ? new DamageRelations.fromJson(json['damage_relations'])
        : null;
    generation = json['generation'] != null
        ? new DoubleDamageFrom.fromJson(json['generation'])
        : null;
    id = json['id'];
    moveDamageClass = json['move_damage_class'] != null
        ? new DoubleDamageFrom.fromJson(json['move_damage_class'])
        : null;
    type = json.containsKey('type') ? json[type] : null;
    }
  }

class DamageRelations {
  List<DoubleDamageFrom>? doubleDamageFrom;
  List<Null>? doubleDamageTo;
  List<Null>? halfDamageFrom;

  DamageRelations(
      {this.doubleDamageFrom,
        this.doubleDamageTo,
        this.halfDamageFrom,});

  DamageRelations.fromJson(Map<String, dynamic> json) {
    if (json['double_damage_from'] != null) {
      doubleDamageFrom = <DoubleDamageFrom>[];
      json['double_damage_from'].forEach((v) {
        doubleDamageFrom!.add(new DoubleDamageFrom.fromJson(v));
      });
    }
    }
  }

class DoubleDamageFrom {
  String? name;
  String? url;

  DoubleDamageFrom({this.name, this.url});

  DoubleDamageFrom.fromJson(Map<String, dynamic> json) {
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