import 'package:proje_bitirme/models/option_model.dart';

class SoruModel {
  late String text;
  late int duration;
  late bool shuffleOptions;
  late List<Option> options;
  SoruModel(
    this.text,
    this.duration,
    this.shuffleOptions,
    this.options,
  );

  SoruModel.fromJson(dynamic json) {
    text = json["text"];
    duration = json["duration"];
    shuffleOptions = json["shuffleOptions"];
    options = List<Option>.from(json["options"].map((x) => Option.fromJson(x)));
  }

  static jsonToObject(dynamic json) {
    List<Option> options = [];
    if (json["options"] != null) {
      options =
          List<Option>.from(json["options"].map((x) => Option.fromJson(x)));
    }
    return SoruModel(
        json["text"], json["duration"], json["shuffleOptions"], options);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = text;
    map["duration"] = duration;
    map["shuffleOptions"] = shuffleOptions;
    map["options"] = List<dynamic>.from(options.map((x) => x.toJson()));
    return map;
  }
}
