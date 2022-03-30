
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Learning extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    int page = 0;

    List<Widget> _learning_page(String image, String text){
        return <Widget>[
          Image.asset(
            image,
            width: size.width*0.98,
            height: size.height*0.7,
          ),
          //const Padding(
          // padding: EdgeInsets.only(bottom: 20),
          Text(
            text,
            style: TextStyle(
              color: Color.fromARGB(255, 151, 94, 186),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ];
    }


    Widget _bottomPanel(){
      return Container(
        child: Row(

        )
      );
    }

    Widget _screen(){
      return Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(176, 86, 80, 222),
                Color.fromARGB(176, 86, 80, 222),
                Color.fromARGB(176, 86, 80, 222),
                Color.fromARGB(176, 86, 80, 222),
                Color.fromARGB(107, 248, 105, 213)
              ],
            )
          ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                child: Container(
                  height: size.height*0.87,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _learning_page('icons/learning1.png', 'Планируй свои события'),
                  ),
                ),
              ),
            ),

          ],
        ),
      );
    }

    return Scaffold(
      body: _screen(),
    );
  }
}