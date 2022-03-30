import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/presentation/routes/routes.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _dark;
  int _currentBody = 1;
  int? currentClientId;
  String clientName = "Абоба";
  String clientEmail = "aboba@mail.ru";

  _onItemTapped(int index) {
    setState(() {
      _currentBody = index;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    _dark = false;
  }

  Future init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentClientId = preferences.getInt('currentId')!;
    final client = await Client.fetchClient(currentClientId!);
    setState(() {
      clientName = client!.name;
      clientEmail = client.email;
    });
    // clientName = client!.name;
    // clientEmail = client.email;
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  void onChange(int i) {
    //Заглушка для bottom_nav_bar
    print(i);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
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
                .addRipple(onTap: () => Helper.showBottomSheet(context)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _currentBody,
          onItemTapped: _onItemTapped,
        ),
        backgroundColor: _dark ? null : Colors.grey.shade200,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    height: 80,
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.birthdayGradient,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 110, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clientName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  clientEmail,
                                  style: const TextStyle(
                                    color: AppTheme.valueEventColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: const Text(
                            "Выйти",
                            style: AppTheme.valueEventText,
                          ).addRipple(
                            onTap: () =>
                                Navigator.pushNamed(context, PagePath.welcome),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Text("Настройки", style: AppTheme.mainPageHeadline),
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    elevation: 4.0,
                    // margin: const EdgeInsets.fromLTRB(5.0, 0.0, 20.0, 0.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.edit,
                            color: AppTheme.boldColorFont,
                          ),
                          title: Text("Редактировать профиль"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, PagePath.editProfile);
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.favorite,
                            color: AppTheme.boldColorFont,
                          ),
                          title: Text("Мои предпочтения"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change language
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.info_outline_rounded,
                            color: AppTheme.boldColorFont,
                          ),
                          title: Text("О приложении"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.pushNamed(context, PagePath.about_app);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child:
                        Text("Уведомления", style: AppTheme.mainPageHeadline),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Push-уведомления"),
                      onChanged: (val) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: false,
                      title: Text("Уведомления на почту"),
                      onChanged: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Приглашения от друзей"),
                      onChanged: (val) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: SwitchListTile(
                      activeColor: AppTheme.boldColorFont,
                      contentPadding: const EdgeInsets.all(0),
                      value: true,
                      title: Text("Обновление приложения"),
                      onChanged: null,
                    ),
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}