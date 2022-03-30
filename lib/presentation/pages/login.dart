import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/presentation/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/page_path.dart';
//import 'package:encrypt/encrypt.dart';

class Login extends StatelessWidget{
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _loginController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();


    Widget _input(String lableText,Icon icon, String hint, TextInputType type, bool obscure, TextEditingController controller){
      return Container(
        //height: size.height*0.08,
        child: TextFormField(
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: lableText,
            labelStyle: TextStyle(
                color: Color.fromARGB(255, 163, 159, 159),
                fontSize: 15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400),
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 0.0),
              child: icon, // Change this icon as per your requirement
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Color.fromARGB(200, 163, 159, 159), fontWeight: FontWeight.normal, fontSize: 15),
          ),
          keyboardType: type,
          controller: controller,
          validator: (val){
            switch(lableText){
              case "Логин" :
                if(val==null || val.isEmpty){
                  return 'Введите логин.';
                }
                return null;
              case "Пароль" :
                //проверка пароля
                if(val==null || val.isEmpty){
                  return 'Введите пароль';
                }
                return null;
            }
          },
        ),
        width: size.width*0.8,
      );
    }

    Future searchClient(String login, String password) async{
      print(login+' '+password);
      final clients = await Client.fetchData();
      for (Client client in clients){
        print(client.username);
        if(client.username==login&&client.pass==password){
          _loginController.clear();
          _passwordController.clear();
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setInt('currentId', client.id!);
          print(preferences.getInt('currentId'));
          return Navigator.pushReplacementNamed(context, PagePath.base);
        }
      }
      _loginController.clear();
      _passwordController.clear();
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пользователь не найден!'), backgroundColor: Colors.redAccent,),
      );
    }


    void submit() {
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (_formKey.currentState!.validate()) {
        searchClient(_loginController.text, _passwordController.text);
      }
    }

    return Scaffold(
        body:  SingleChildScrollView (
        child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(107, 248, 105, 213),
                    Color.fromARGB(176, 86, 80, 222)
                  ],
                )
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: size.height*0.0008),
                    child: Image.asset(
                      Resources.apps_icon,
                      height: 129,
                      width: 112,
                    ),
                    // child: Image.asset(
                    //   "icons/apps_icon1.png",
                    //   height: 129,
                    //   width: 112,
                    // ),
                  ),
                  Container(
                      //height: size.height*0.75,
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                        child: Container(
                          height: size.height*0.60,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 40, top: 10, bottom: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text("Авторизация", style: TextStyle(color: Color.fromARGB(255, 151, 94, 186), fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 23),)
                                ),
                                Container(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        _input("Логин", Icon(Icons.person_outlined, color: Color.fromARGB(255, 151, 94, 186)), "event11", TextInputType.name, false, _loginController),
                                        _input("Пароль", Icon(Icons.vpn_key_outlined, color: Color.fromARGB(255, 151, 94, 186)), "Event!11", TextInputType.visiblePassword, true, _passwordController),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 40),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: RaisedButton(
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 105,),
                                      color: Color.fromARGB(222, 151, 94, 186),
                                      splashColor: Color.fromARGB(255, 191, 80, 246),
                                      onPressed: submit,
                                      child: const Text(
                                        "Войти",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Еще нет аккаунта?",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 248, 105, 148)
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pushReplacementNamed(context, PagePath.registration);
                                      },
                                      child: Text(" Зарегистрироваться",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 248, 105, 148),
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  )
                ]
            )
        )
    ));
  }
}