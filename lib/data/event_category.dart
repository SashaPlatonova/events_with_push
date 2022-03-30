import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

EventCategory categoryFromJson(String str) {
  final jsonData = json.decode(str);
  return EventCategory.fromJson(jsonData);
}

String categoryToJson(EventCategory data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class EventCategory {
  final int id;
  final String title;
  final String color;

  EventCategory(
      {
        required this.id, required this.title, required this.color
      }
        );
  factory EventCategory.fromJson(Map<String, dynamic> json) => new EventCategory(
      id: json["id"],
      title: json["title"],
      color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "color": color,
  };


  static Future<List<EventCategory>> fetchData() async {
    List<EventCategory> clients = [];
    var url = "http://10.0.2.2:8080/api/category/all";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        clients.add(EventCategory.fromJson(cl));
      }
    }
    return clients;
  }
  static Future<EventCategory> fetchCatById(int id) async {
    EventCategory? cat;
    var url = "http://10.0.2.2:8080/api/category/id?id=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      cat = EventCategory.fromJson(res);
    }
    return cat!;
  }
}