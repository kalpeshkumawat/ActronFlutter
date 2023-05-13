import 'dart:convert';

SearchRegisterData searchRegisterDataFromJson(String str) =>
    SearchRegisterData.fromJson(json.decode(str));

String searchRegisterDataToJson(SearchRegisterData data) =>
    json.encode(data.toJson());

class SearchRegisterData {
  SearchRegisterData({
    required this.name,
    required this.startIndex,
    required this.length,
    required this.type,
    required this.value,
  });

  String name;
  int startIndex;
  int length;
  String type;
  String value;

  factory SearchRegisterData.fromJson(Map<String, dynamic> json) =>
      SearchRegisterData(
        name: json["name"],
        startIndex: json["startIndex"],
        length: json["length"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "startIndex": startIndex,
        "length": length,
        "type": type,
        "value": value,
      };
}
