import 'package:flutter_app/presentation/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/client.dart';
import '../routes/page_path.dart';
import '../widgets/custom_date/filter_wrapper.dart';
import '../widgets/state_widgets.dart';

class EditProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage>{
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static int id = 0;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController1 = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();

  Future searchClient() async{
    print('поиск пользователя');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt('currentId')!;
    final client = await Client.fetchClient(id);
    _emailController.text = client!.email;
    _nameController.text = client.name;
    _loginController.text = client.username;
    _phoneController.text = client.phone;
    _passwordController1.text = client.pass;
    _passwordController2.text = client.pass;
    print(id);
  }

  @override
  void initState()
  {
    super.initState();
    searchClient();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget _input(String lableText,Icon icon, String hint, TextInputType type, bool obscure, TextEditingController controller){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
        child: TextFormField(
          obscureText: obscure,
          decoration: InputDecoration(
            border: OutlineInputBorder( borderSide: BorderSide(color: AppTheme.purpleBlue)),
            focusColor: AppTheme.purpleBlue,
            labelText: lableText,
            labelStyle: TextStyle(
                color: Color.fromARGB(255, 163, 159, 159),
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500),
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
      );
    }

    submit() {
      print(id);
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (_formKey.currentState!.validate()) {
        Client client = Client(
            id: id,
            name: _nameController.text,
            email: _emailController.text,
            username: _loginController.text,
            phone: _phoneController.text,
            pass: _passwordController1.text,
            social: ''
        );
        Client.updateClient(client);
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Информация успешно обновлена!'), backgroundColor: AppTheme.pinkColorFont),
        );
        }
      }
    Future _deleteById() async {
      final client = await Client.fetchClient(id);
      print(client!.id);
      print('удаление');
      await Client.deleteClient(client);
    }

    void _delete() {
      showDialog<bool>(
        context: context,
        builder: (context) => FilterWrapper(
          blurAmount: 5,
          child: AlertDialog(
            title: Text("Удалить аккаунт?", style: AppTheme.eventPanelHeadline),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GarbageWidget(),
                SizedBox(height: 20),
                Text(
                  'Вы уверены, что хотите удалить аккаунт?',
                  style: AppTheme.eventPanelHeadline,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Отмена',
                    style: AppTheme.mainPageSmallHeadline,
                  )),
              TextButton(
                onPressed: () {
                  print('при нажатии');
                  _deleteById();
                  SnackBar(content: Text('Аккаунт успешно удален'), backgroundColor: AppTheme.purpleDark);
                  Navigator.pushReplacementNamed(context, PagePath.welcome);
                },
                child: Text(
                  'Удалить',
                  style: AppTheme.mainPageSmallHeadline,
                ),
              ),
            ],
            insetPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
          ),
        ),
      ).then((isDelete) {
        if(isDelete != null && isDelete){
          Navigator.pop(context);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.purpleBlue,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, PagePath.profile),
          padding: EdgeInsets.only(left: 0),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _delete,
            icon: const Icon(Icons.delete_forever),
          )
        ],
        title: const Text('Мой аккаунт', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
      ),
      body: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(vertical: size.height*0.1, horizontal: size.width*0.1),
        child:Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text('Редактирование профиля', style: TextStyle(color: Color.fromARGB(222, 151, 94, 186), fontWeight: FontWeight.w700, fontSize: 25)),
                  SizedBox(height: 20),
                  _input("Email", Icon(Icons.email, color: Color.fromARGB(255, 151, 94, 186)), "event@mail.ru", TextInputType.emailAddress, false, _emailController),
                  SizedBox(height: 20),
                  _input("Имя", Icon(Icons.account_circle, color: Color.fromARGB(255, 151, 94, 186)), "Светлана", TextInputType.name, false, _nameController),
                  SizedBox(height: 20),
                  _input("Логин", Icon(Icons.person, color: Color.fromARGB(255, 151, 94, 186)), "event11", TextInputType.name, false, _loginController),
                  SizedBox(height: 20),
                  _input("Телефон", Icon(Icons.phone, color: Color.fromARGB(255, 151, 94, 186)), "+79121211212", TextInputType.phone, false, _phoneController),
                  SizedBox(height: 20),
                  _input("Пароль", Icon(Icons.vpn_key, color: Color.fromARGB(255, 151, 94, 186)), "Event!11", TextInputType.visiblePassword, true, _passwordController1),
                  SizedBox(height: 20),
                  _input("Повторный пароль", Icon(Icons.vpn_key_sharp, color: Color.fromARGB(255, 151, 94, 186)), "Event!11", TextInputType.visiblePassword, true, _passwordController2),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: size.width*0.25,),
                  color: AppTheme.purpleBlue,
                  splashColor: Color.fromARGB(255, 191, 80, 246),
                  onPressed: submit,
                  child: const Text(
                    "Сохранить",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ) ,
      ),
    );
  }

}
