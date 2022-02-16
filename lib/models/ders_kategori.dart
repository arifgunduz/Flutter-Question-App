class DersKategori {
  late int id;
  late String name;
  late String imagePath;
  DersKategori(
    this.id,
    this.name,
    this.imagePath,
  );
  DersKategori.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    imagePath = json["imagePath"];
  }

  static jsonToObject(dynamic json) {
    return DersKategori(json["id"], json["name"], json["imagePath"]);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["imagePath"] = imagePath;
    return map;
  }
}
