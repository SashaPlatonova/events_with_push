import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Preference {
  final int id;
  final String title;
  final String img;

  Preference(
      {required this.id, required this.title, required this.img});

  factory Preference.fromJson(Map<String, dynamic> json) => new Preference(
    id: json["id"],
    title: json["title"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
  };

  static Future<List<Preference>> fetchByClient(int id) async {
    List<Preference> prefes = [];
    var url = "http://10.0.2.2:8080/api/preferences/client?client=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        prefes.add(Preference.fromJson(cl));
      }
    }
    return prefes;
  }

}