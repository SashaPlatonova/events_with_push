import 'package:flutter_app/data/entities.dart';
import 'package:flutter_app/presentation/routes/argument_bundle.dart';
import 'package:flutter_app/presentation/routes/page_path.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/task_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EventItemWidget extends StatelessWidget {
  final Event event;
  final EventCategory category;
  final Animation<double> animation;

  const EventItemWidget({
    Key? key,
    required this.event,
    required this.category, required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
      child: GestureDetector(
        onTap: () {
          showCupertinoModalBottomSheet(
            expand: false,
            context: context,
            enableDrag: true,
            topRadius: Radius.circular(20),
            backgroundColor: Colors.transparent,
            builder: (context) =>
                TaskSheet(
                    isUpdate: true,
                    event: event,
                    categoryId: category.id,
                ),
          );
        },
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
                Text(event.title, style: AppTheme.eventPanelHeadline),
                SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(Resources.clock, width: 20),
                    SizedBox(width: 8),
                    Text(
                        event.startTime != null
                            ? DateFormat('HH:mm, MMM dd, yyyy', 'ru').format(event.startTime!)
                            : 'Дата не указана',
                        style: AppTheme.dateEventPanelText),
                  ],
                ),
                SizedBox(height: 16),
                Wrap(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(category.title, style: AppTheme.eventPanelHeadline),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (event.startTime!.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch
                            ? AppTheme.grey
                            : AppTheme.grey)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                          event.description,
                          style: AppTheme.eventPanelHeadline),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Гости', style: AppTheme.eventPanelHeadline)
                    ).addRipple(onTap: () {
                      Navigator.pushNamed(
                        context,
                        PagePath.clientList,
                        arguments: ArgumentBundle(extras: {
                          Keys.eventId: event.id,
                        }, identifier: 'client list'),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}