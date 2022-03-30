import 'dart:convert';
import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Event eventFromJson(String str) {
  final jsonData = json.decode(str);
  return Event.fromJson(jsonData);
}

String eventToJson(Event event) {
  final dyn = event.toJson();
  return json.encode(dyn);
}

class Event {
  final int? id;
  final EventCategory category;
  final String title;
  final String description;
  final String address;
  final double? budget;
  DateTime? startTime;
  final Client owner;

  Event(
      {this.id,
        required this.category,
        required this.title,
        required this.description,
        required this.address,
        this.budget,
        this.startTime,
        required this.owner}
        );

  factory Event.fromJson(Map<String, dynamic> json) => new Event(
      id: json["id"],
      category: EventCategory.fromJson(json["category"]),
      title: json["title"],
      description: json["description"],
      address: json["address"],
      budget: json["budget"],
      startTime: DateTime.parse(json["startTime"]),
      // DateTime.fromMillisecondsSinceEpoch(json["startTime"]),
      owner: Client.fromJson(json["owner"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "title": title,
    "description": description,
    "address": address,
    "budget": budget,
    "startTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime!),
    "owner": owner
  };

  static Future<List<Event>> fetchData(int id) async {
    List<Event> events = [];
    var url = "http://10.0.2.2:8080/api/invitation/client?id=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        events.add(Event.fromJson(cl));
      }
    }
    return events;
  }

  static Future<List<Event>> fetchEventByCat(int id, int client) async {
    List<Event> events = [];
    var url = "http://10.0.2.2:8080/api/events/category?category=$id&client=$client";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        events.add(Event.fromJson(cl));
      }
    }
    return events;
  }

  static Future<List<Event>> fetchEventByTitle(String title, int owner) async {
    List<Event> events = [];
    var url = "http://10.0.2.2:8080/api/events/title?title=$title&owner=$owner";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        events.add(Event.fromJson(cl));
      }
    }
    print(events);
    return events;
  }

  static Future<List<Event>> fetchEventByMonth(int month, int id, int cat) async {
    List<Event> events = [];
    var url = "http://10.0.2.2:8080/api/invitation/client/params?id=$id&cat=$cat&month=$month";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode==200){
      var res = json.decode(utf8.decode(response.bodyBytes));
      for (var cl in res) {
        events.add(Event.fromJson(cl));
      }
    }
    return events;
  }

  static Future<http.Response> addEvent(Event event) async {
    return http.post(
      Uri.parse("http://10.0.2.2:8080/api/events/add"),
      headers:{"Content-Type": "application/json"},
      body: eventToJson(event)
    );
  }

  static Future<http.Response> updateEvent(Event event) async {
    return http.put(
        Uri.parse("http://10.0.2.2:8080/api/events/update"),
        headers:{"Content-Type": "application/json"},
        body: eventToJson(event)
    );
  }

  static Future<http.Response> deleteEvent(Event event) async {
    return http.delete(
      Uri.parse("http://10.0.2.2:8080/api/events/delete"),
        headers:{"Content-Type": "application/json"},
        body: eventToJson(event)
    );
  }
}
