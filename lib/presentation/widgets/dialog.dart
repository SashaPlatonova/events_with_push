import 'dart:async';

import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/buttons.dart';
import 'package:flutter_app/presentation/widgets/state_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// A Custom Dialog that displays a single question & list of answers.
class MultiSelectDialog extends StatefulWidget {
  /// List to display the answer.
  List<Client> answers =[];

  final Widget question;
  final List<Client> selectedItems = [];
  static Map<Client, bool>? mappedItem;
  final List<int> invitedClient;

  MultiSelectDialog(
      {Key? key, required this.answers, required this.question, required this.invitedClient})
      : super(key: key);

  @override
  State<MultiSelectDialog> createState() => MultiSelectDialogState();

}

  class MultiSelectDialogState extends State<MultiSelectDialog>{
  /// Function that converts the list answer to a map.
    static Map<Client, bool>? mappedItem;
    TextEditingController searchController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    Timer? debouncer;
    int? currentClientId;
    String? clientName;

    Future init() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      currentClientId = preferences.getInt('currentId')!;
      final client = await Client.fetchClient(currentClientId!);
      setState(() {
        clientName = client!.name;
      });
      // clientName = client!.name;
      // clientEmail = client.email;
    }

  Map<Client, bool> initMap() {
    print(widget.invitedClient.toString());
    return mappedItem = { for (var item in widget.answers) item :  widget.invitedClient.contains(item.id)};
  }

    void debounce(
        VoidCallback callback, {
          Duration duration = const Duration(milliseconds: 1000),
        }) {
      if (debouncer != null) {
        debouncer!.cancel();
      }

      debouncer = Timer(duration, callback);
    }

    _launchEmail(email) async {
    print('****');
      launch("mailto:$email?subject=Приглашение&body=$clientName приглашет вас в приложение Event Planning%20plugin");
    }

  Future searchClient(String val) async => debounce(() async {
    initMap();
    setState((){
      mappedItem!.removeWhere((key, value) => !key.username.startsWith(val));
    });
  });


  @override
  Widget build(BuildContext context) {
    if (mappedItem == null) {
      initMap();
    }
    init();
    return SimpleDialog(
      title: widget.question,
      contentPadding: EdgeInsets.all(10),
      children: [
        TextFormField(
          style: AppTheme.eventPanelHeadline.withBlack,
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Введите имя...',
              hintStyle: AppTheme.hintsText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(
                      color: AppTheme.borderPurple
                  )
              )
          ),
          textInputAction: TextInputAction.search,
          onChanged: (val) {
            searchClient(val);
          },
        ),
        ...mappedItem!.keys.map((Client key) {
          return StatefulBuilder(
            builder: (_, StateSetter setState) => CheckboxListTile(
                title: Text(key.username), // Displays the option
                value: mappedItem![key], // Displays checked or unchecked value
                controlAffinity: ListTileControlAffinity.platform,
                onChanged: (value) => setState(() => mappedItem![key] = value!)),
          );
        }).toList(),
        list()
      ],
    );
  }

   Widget list() {
     if (mappedItem!.keys.isEmpty) {
       return
           Container(
             height: 350,
             width: 200,
               child:
               Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Center(
                     child: LottieBuilder.asset(Resources.empty,
                         height: MediaQuery.of(context).size.height * 0.2),
                   ),
                   Container(
                     child: Text(
                         'Пользователь с таким юзернэймом не зарегистрирован, отправьте ему приглашение',
                         style: AppTheme.hintsText),
                   ),
                   TextFormField(
                     style: AppTheme.eventPanelHeadline.withBlack,
                     controller: emailController,
                     decoration: InputDecoration(
                         hintText: 'Введите email...',
                         hintStyle: AppTheme.hintsText,
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(7),
                             borderSide: BorderSide(
                                 color: AppTheme.borderPurple
                             )
                         )
                     ),

                   ),
                   RippleButton(text: 'Отправить приглашение', onTap: () => {
                     _launchEmail(emailController.text),
                     searchClient('')
                   }),
                 ],
               ));
     }
     else return Align(
         alignment: Alignment.center,
         child: ElevatedButton(
             style: ButtonStyle(visualDensity: VisualDensity.comfortable,
                 backgroundColor: MaterialStateProperty.all<Color>(AppTheme.bottomAddSheetDate)),
             child: Text('Пригласить'),
             onPressed: () {
               // Clear the list
               widget.selectedItems.clear();

               // Traverse each map entry
               mappedItem!.forEach((key, value) {
                 if (value == true) {
                   widget.selectedItems.add(key);
                 }
               });

               // Close the Dialog & return selectedItems
               Navigator.pop(context, widget.selectedItems);
             }));
   }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<Client, bool>>('mappedItem', mappedItem));
    properties.add(DiagnosticsProperty<Map<Client, bool>>('mappedItem', mappedItem));
  }

}
