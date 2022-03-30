import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:flutter_app/data/event.dart';
import 'package:flutter_app/data/event_category.dart';
import 'package:flutter_app/presentation/routes/routes.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/ClientItemWIdget.dart';
import 'package:flutter_app/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter_app/presentation/widgets/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientList extends StatefulWidget {

  final ArgumentBundle bundle;

  const ClientList({Key? key, required this.bundle})
      : super(key: key);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {

  int? currentClientId;
  Client? client;
  List<Client> list = [];
  List<List<Preference>> preference = [];
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

  getData() async {
    list = await Client.fetchByEvent(widget.bundle.extras[Keys.eventId]);
    for (var i = 0; i<list.length; i++) {
      preference.add(await Preference.fetchByClient(list[i].id!));
      print(preference[i].toString());
    }
  }

  void onChange(int i) {
    //Заглушка для bottom_nav_bar
    print(i);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    getCurrentClient();
    getData();
    print("on list page");
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
                _onGoing(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0, onItemTapped: onChange),
    );
  }

  _topBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              //margin: const EdgeInsets.fromLTRB(0,0,0,0),
              child: const Icon(Icons.arrow_back, color: AppTheme.borderPurple))
              .addRipple(
            onTap: () => Navigator.pushNamed(context, PagePath.base),
          ),
          Text(
            DateFormat('MMM dd, yyyy', 'ru').format(DateTime.now()),
            style: AppTheme.searchString,
          ),
          SizedBox(width: 20),
          Text(
            'Список гостей',
            style: AppTheme.mainPageSmallHeadline
          )
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
          FutureBuilder<String>(
              future: _calculation,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return taskListView(list);
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

  Widget taskListView(List<Client> data) {
    return LiveList.options(
      options: Helper.options,
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final item = data[index];
        final pref = preference[index];
        print(pref.toString());
        return ClientItemWidget(
          client: item,
          animation: animation,
          preference: pref,
        );
      },
    );
  }
}