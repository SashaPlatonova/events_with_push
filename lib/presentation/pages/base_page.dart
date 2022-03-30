import 'package:flutter_app/presentation/pages/detail_category_task_page.dart';
import 'package:flutter_app/presentation/pages/pages.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentBody = 0;

  static List<Widget> get bodyList => [
    DashboardPage(),
    SearchPage()
    // BagPage(),
    // ProfilePage(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _currentBody = index;
    });
    print(bodyList[_currentBody]);
  }

  Widget get _getPage => bodyList[_currentBody];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage,
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 25),
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.bottomNavigationPurple,
          boxShadow: AppTheme.getShadow(AppTheme.darkBorderPurple),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(56),
          child: Icon(Icons.add, color: Colors.white)
              .addRipple(onTap: () =>
                Helper.showBottomSheet(context))
          ,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _currentBody,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
