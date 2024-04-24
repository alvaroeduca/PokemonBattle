class HealthObjectData {
  int? id;
  List<Items>? items;
  String? name;
  List<Names>? names;
  Items? pocket;


  HealthObjectData({this.id, this.items, this.name, this.names, this.pocket});

  HealthObjectData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    name = json['name'];
    if (json['names'] != null) {
      names = <Names>[];
      json['names'].forEach((v) {
        names!.add(new Names.fromJson(v));
      });
    }
    pocket = json['pocket'] != null ? new Items.fromJson(json['pocket']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    if (this.names != null) {
      data['names'] = this.names!.map((v) => v.toJson()).toList();
    }
    if (this.pocket != null) {
      data['pocket'] = this.pocket!.toJson();
    }
    return data;
  }
}

class Items {
  String? name;
  String? url;

  Items({this.name, this.url});

  Items.fromJson(Map<String, dynamic> json) {
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

class Names {
  Items? language;
  String? name;

  Names({this.language, this.name});

  Names.fromJson(Map<String, dynamic> json) {
    language =
    json['language'] != null ? new Items.fromJson(json['language']) : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.language != null) {
      data['language'] = this.language!.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}