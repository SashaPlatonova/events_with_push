import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/task_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientItemWidget extends StatelessWidget {
  final Client client;
  final Animation<double> animation;
  final List<Preference> preference;

  const ClientItemWidget({
    Key? key,
    required this.client,
    required this.animation, required this.preference,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.pinkColorFont.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(client.username, style: AppTheme.mainPageHeadline),
                SizedBox(height: 16),
                Text('Имя: ' + client.name, style: AppTheme.eventPanelHeadline),
                SizedBox(height: 16),
                Text('Телефон: ' + client.phone, style: AppTheme.eventPanelHeadline),
                SizedBox(height: 16),
                Text('E-mail: ' + client.email, style: AppTheme.eventPanelHeadline),
                SizedBox(height: 16),
                Container(
                  height: 50,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(left: 0, top: 8, bottom: 0, right: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: preference.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(preference[index].title, style: AppTheme.eventPanelHeadline),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}