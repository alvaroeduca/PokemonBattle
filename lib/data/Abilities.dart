class AbilitiesType {
  List<EffectEntries>? effectEntries;

  AbilitiesType(
      {this.effectEntries,});

  AbilitiesType.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('effect_entries')) {
      effectEntries = <EffectEntries>[];
      json['effect_entries'].forEach((v) {
        effectEntries!.add(new EffectEntries.fromJson(v));
      });
    }
  }
}

class EffectEntries {
  String? effect;

  EffectEntries({this.effect});

  EffectEntries.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('effect')) {
      effect = json['effect'];
    }
  }

}