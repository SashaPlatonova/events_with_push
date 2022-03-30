import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed:(){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Colors.transparent
          ),
        ),
        backgroundColor: AppTheme.purpleBlue,
        elevation: 0,
        title: Row(
          children: [
            Container(
                padding: const EdgeInsets.only(right: 140),
                child: Text(
                  'О приложении',
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      color: AppTheme.white
                  ),
                )
            ),
          ],
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontFamily: 'Manrope',
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold
        ),
      ),
      body: Container(
          margin: const EdgeInsets.only(
              top: 135,
              left: 25
          ),
          height: 150,
          width: 300,
          // decoration: BoxDecoration(
          //   color:  AppTheme.purpleBlue,
          //   borderRadius: BorderRadius.circular(10),
          // ),
          child: Center(
            child:
            Image.asset(
              Resources.icon_outlined,
            ),
            //
            // Text(
            //     'ИВЕНТ',
            //     style: TextStyle(
            //       fontSize: 25,
            //       color: AppTheme.white,
            //       fontFamily: 'Manrope',
            //       fontWeight: FontWeight.w800,
            //     )
            // ),
          )
      ),
      bottomSheet: Container(
        child:
        Container(
          height: 346,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
            boxShadow: customBottomShadow(Theme.of(context).colorScheme.brightness),
            color: AppTheme.purpleBlue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'by RATS Lab',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.white,
                        fontFamily: 'Manrope',
                        fontSize: 15,
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'Версия 1.0',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onBackground
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'от 30 марта  2022',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Manrope',
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w800,
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      '2021',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onBackground
                      )
                  )
              ),
              // Container(
              //   padding: const EdgeInsets.only(top: 230),
              //   child: Text(
              //     '2021',
              //     style: TextStyle(
              //         fontWeight: FontWeight.w800,
              //         fontSize: 10,
              //         fontFamily: 'Manrope',
              //         color: Theme.of(context).primaryColor
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<BoxShadow> customBottomShadow (Brightness br){
    if (br == Brightness.dark){
      return  [const BoxShadow(
        spreadRadius: 0,
        blurRadius: 8,
        color: Color.fromRGBO(0, 0, 0, 0.07),
        offset: Offset(0, -6),
      ),
        const BoxShadow(
          color: Color.fromRGBO(255, 255, 255, 0.15),
          blurRadius: 10,
          offset: Offset(0, -4),
        )
      ];
    }
    return [const BoxShadow(
      spreadRadius: 0,
      blurRadius: 28,
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, -6),
    )
    ];
  }

  List<BoxShadow> customShadows(Brightness br){
    if (br == Brightness.dark){
      return [const BoxShadow(
        blurRadius: 8,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.07),
        offset: Offset(0, 4),
      ),
        const BoxShadow(
          spreadRadius: 0,
          blurRadius: 10,
          color: Color.fromRGBO(255, 255, 255, 0.1),
          offset: Offset(0, 0),
        )
      ];
    }
    return [const BoxShadow(
      blurRadius: 4,
      spreadRadius: 0,
      color: Color.fromRGBO(0, 0, 0, 0.05),
      offset: Offset(0, 4),
    ),
      const BoxShadow(
        spreadRadius: 0,
        blurRadius: 4,
        color: Color.fromRGBO(255, 255, 255, 0.05),
        offset: Offset(0, -4),
      )
    ];
  }
}