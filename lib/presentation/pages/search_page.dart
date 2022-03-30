import 'dart:async';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/search_widget.dart';
import 'package:flutter_app/presentation/widgets/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Event> events = [];
  String query = '';
  Timer? debouncer;
  int? currentClientId;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentClientId = preferences.getInt('currentId')!;
    final events = await Event.fetchData(currentClientId!);
    print(currentClientId);
    setState(() => this.events = events);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            buildSearch(),
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 200, 0),
                child: Text(
                  'Найдено событий',
                  style: AppTheme.mainPageSmallHeadline,
                )),
            Expanded(
              child: LiveList.options(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                options: Helper.options,
                itemCount: events.length,
                itemBuilder: (context, index, animation) {
                  final event = events[index];
                  return EventItemWidget(
                      event: event,
                      category: event.category,
                      animation: animation);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Поиск событий',
        onChanged: searchEvent,
      );

  Future searchEvent(String query) async => debounce(() async {
        final events = await Event.fetchEventByTitle(query, currentClientId!);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.events = events;
        });
      });

  Widget buildEvent(Event event) => ListTile(
        title: Text(event.title),
        subtitle: Text(event.category.title),
      );
}
