import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:flutter_app/data/event.dart';
import 'package:flutter_app/data/event_category.dart';
import 'package:flutter_app/presentation/routes/routes.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  List<EventCategory> _cats = [];
  List<Event> _myEvents = [];
  int? currentClientId;
  Client? client;
  List<List<Event>> _eventsByCat = [];
  List<Event> current = [];

  // bool isAll = false;

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 3),
        () => 'Data Loaded',
  );

  Future<void> getCurrentClient() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentClientId = preferences.getInt('currentId');
    });
  }

  getData(bool isAll) async {
    _cats = await EventCategory.fetchData();
    _myEvents = await Event.fetchData(currentClientId!);
    current = _myEvents;
    if (!isAll) {
      current.removeWhere((element) =>
      element.startTime!.millisecondsSinceEpoch <= DateTime
          .now()
          .millisecondsSinceEpoch);
    }
    client = await Client.fetchClient(currentClientId!);
    for (var i = 0; i < _cats.length; i++) {
      _eventsByCat.add(await Event.fetchEventByCat(_cats[i].id, currentClientId!));
    }

  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    getCurrentClient();
    getData(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                _topBar(),
                _myTasks(),
                _onGoing(),
                // _complete(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMM dd, yyyy', 'ru').format(DateTime.now()),
            style: AppTheme.searchString,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Hero(
              tag: Keys.heroSearch,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.boldColorFont),
                ),
                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Поиск событий',
                        style: AppTheme.searchString,
                      ),
                    ),
                    Icon(
                      Icons.search_rounded,
                      color: AppTheme.borderPurple,
                    ),
                  ],
                ),
              ).addRipple(
                onTap: () => Navigator.pushNamed(context, PagePath.search),),
            ),
          ),
        ],
      ),
    );
  }

  _myTasks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Мои праздники',
                style: AppTheme.mainPageHeadline,
                textAlign: TextAlign.start,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Посмотреть все',
                  style: AppTheme.mainPageSmallHeadline,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          FutureBuilder<String>(
              future: _calculation,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return taskCategoryGridView(_cats);
                }
                else {
                  return Center(
                      child:
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(Resources.loading, ),
                          const SizedBox(height: 20),
                          // Text('ИВЕНТ', style: AppTheme.mainPageHeadline),
                        ],
                      ));
                }
              })
        ],
      ),
    );
  }

  _onGoing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                  tag: Keys.heroStatus + StatusType.ON_GOING.toString(),
                  child: TextButton(
                    onPressed: () =>
                        setState(() {
                          getData(false);
                        }),
                    child:
                    Text(
                      'Предстоящие',
                      style: AppTheme.mainPageHeadline,
                      textAlign: TextAlign.start,
                    ),
                  )),
              TextButton(
                onPressed: () =>
                    setState(() {
                      getData(true);
                    }),
                child: Text(
                  'Посмотреть все',
                  style: AppTheme.mainPageSmallHeadline,
                ),
              ),
            ],
          ),
          FutureBuilder<String>(
              future: _calculation,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return taskListView(current);
                }
                else {
                  return Center(
                      child:
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(Resources.loading),
                          const SizedBox(height: 80),
                          // Text('ИВЕНТ', style: AppTheme.mainPageHeadline),
                        ],
                      ));
                }
              }
          )
        ],
      ),
    );
  }

  Widget taskCategoryGridView(List<EventCategory> data) {
    List<EventCategory> dataList = data;
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        final taskItem = dataList[index];
        return taskCategoryItemWidget(taskItem);
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2.4 : 1.8),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
    );
  }

  Widget taskCategoryItemWidget(EventCategory category) {
    var total = _eventsByCat[category.id - 1].length;
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.getGradientByName(category.color),
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppTheme.getShadow(AppTheme
            .getGradientByName(category.color)
            .colors[0]),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: AutoSizeText(
                  (category.id).toString(),
                  style: AppTheme.eventPanelHeadline,
                  minFontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 12),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Hero(
                      tag: Keys.heroTitleCategory + category.id.toString(),
                      child: Text(
                        category.title,
                        style: AppTheme.eventHeadline,
                        maxLines: category.id.isEven ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_right, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$total Событий',
              style: AppTheme.valueEventText,
            ),
          ],
        ),
      ).addRipple(onTap: () {
        Navigator.pushNamed(
          context,
          PagePath.detailCategory,
          arguments: ArgumentBundle(extras: {
            Keys.categoryItem: category,
            Keys.index: category.id,
          }, identifier: 'detail Category'),
        );
      }),
    );
  }

  Widget taskListView(List<Event> data) {
    return LiveList.options(
      options: Helper.options,
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final item = data[index];
        return EventItemWidget(
          event: item,
          category: _cats[item.category.id - 1], animation: animation,
        );
      },
    );
  }
}
