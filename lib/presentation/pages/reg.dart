import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:encrypt/encrypt.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/client.dart';
import '../routes/page_path.dart';

class Reg extends StatelessWidget{
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _loginController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _passwordController1 = TextEditingController();
    TextEditingController _passwordController2 = TextEditingController();


    Future<bool> checkClient(String login) async {
      final clients = await Client.fetchData();
      for (Client client in clients){
        if(client.username==login){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Такой логин уже существует!'),
              backgroundColor: Colors.redAccent));
          return false;
        }
      }
      return true;
    }

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
              case "Email" :
                if(val==null || !val.contains("@") || val.isEmpty){
                  return 'Email введен неверно.';
                }
                return null;
              case "Имя" :
                if(val==null || val.isEmpty){
                  return 'Введите имя.';
                }
                return null;
              case "Логин" :
                if(val==null || val.isEmpty){
                  return 'Введите логин.';
                }
                return null;
              case "Телефон" :
                if(val==null || val.isEmpty){
                  return 'Введите телефон.';
                }
                if(val.length>11 || val.length<11){
                  return 'Телефон введен неверно.';
                }
                return null;
              case "Пароль" :
                if(val==null || val.isEmpty){
                  return 'Введите пароль';
                }
                return null;
              case "Повторный пароль" :
                if(val!=_passwordController1.text){
                  return 'Пароли не совпадают!';
                }
                return null;
            }
          },
        ),
        width: size.width*0.8,
      );
    }

    Future searchClient(String login, String password) async{
      final clients = await Client.fetchData();
      for (Client client in clients){
        if(client.username==login&&client.pass==password){
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setInt('currentId', client.id!);
          print(preferences.getInt('currentId'));
          return ;
        }
      }

      return print("пользователь не найден...");

    }

    Future<void> submit() async {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (_formKey.currentState!.validate()) {
        var check = await checkClient(_loginController.text);
        if(check==true){
          Client client = Client(
              id: 0,
              name: _nameController.text,
              email: _emailController.text,
              username: _loginController.text,
              phone: _phoneController.text,
              pass: _passwordController1.text,
              social: ''
          );
          await Client.addClient(client);
          _emailController.clear();
          _nameController.clear();
          _loginController.clear();
          _phoneController.clear();
          _passwordController1.clear();
          _passwordController2.clear();
          searchClient(client.username, client.pass);
          await Navigator.pushReplacementNamed(context, PagePath.base);
        }
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
                      "assets/icons/apps_icon1.png",
                      height: 129,
                      width: 112,
                      //alignment: Alignment.bottomLeft,
                    ),
                  ),
                  Container(
                      //height: size.height*0.75,
                      //width: double.infinity,
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                        child: Container(
                          //height: size.height*0.75,
                          //width: double.infinity,
                          //alignment: Alignment.bottomCenter,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 40, top: 10, bottom: 10),
                                    alignment: Alignment.topLeft,
                                    child: Text("Регистрация", style: TextStyle(color: Color.fromARGB(255, 151, 94, 186), fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, fontSize: 23),)
                                ),
                                Container(
                                  //padding: EdgeInsets.only(bottom: 10),
                                  //height: size.height*0.50,
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        _input("Email", Icon(Icons.email_outlined, color: Color.fromARGB(255, 151, 94, 186)), "event@mail.ru", TextInputType.emailAddress, false, _emailController),
                                        _input("Имя", Icon(Icons.account_circle_outlined, color: Color.fromARGB(255, 151, 94, 186)), "Светлана", TextInputType.name, false, _nameController),
                                        _input("Логин", Icon(Icons.person_outlined, color: Color.fromARGB(255, 151, 94, 186)), "event11", TextInputType.name, false, _loginController),
                                        _input("Телефон", Icon(Icons.phone_outlined, color: Color.fromARGB(255, 151, 94, 186)), "+79121211212", TextInputType.name, false, _phoneController),
                                        _input("Пароль", Icon(Icons.vpn_key_outlined, color: Color.fromARGB(255, 151, 94, 186)), "Event!11", TextInputType.visiblePassword, true, _passwordController1),
                                        _input("Повторный пароль", Icon(Icons.vpn_key_sharp, color: Color.fromARGB(255, 151, 94, 186)), "Event!11", TextInputType.visiblePassword, true, _passwordController2),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 25),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: RaisedButton(
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40,),
                                      color: Color.fromARGB(222, 151, 94, 186),
                                      splashColor: Color.fromARGB(255, 191, 80, 246),
                                      onPressed: submit,
                                      child: const Text(
                                        "Зарегистрироваться",
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
                                    Text("Есть аккаунт?",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 248, 105, 148)
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){Navigator.pushReplacementNamed(context, PagePath.auth);},
                                      child: Text(" Войти",
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
    )
    );
  }
}

