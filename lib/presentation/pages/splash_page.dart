import 'package:flutter_app/presentation/routes/routes.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    _navigateOtherScreen();
    super.initState();
  }

  void _navigateOtherScreen() {
      Future.delayed(Duration(seconds: 2))
          .then((_) => Navigator.pushReplacementNamed(context, PagePath.welcome ));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 300,
              child: Image.asset(
                Resources.icon_outlined,
              ),
            ),
            const SizedBox(height: 100, width: 200),
            // Text('ИВЕНТ', style: AppTheme.mainPageHeadline),
          ],
        ),
      ),
    );
  }
}
