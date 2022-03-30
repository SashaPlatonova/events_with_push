import 'package:flutter_app/data/client.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:flutter_app/data/entities.dart';
import 'package:flutter_app/presentation/utils/utils.dart';
import 'package:flutter_app/presentation/widgets/custom_date/filter_wrapper.dart';
import 'package:flutter_app/presentation/widgets/dialog.dart';
import 'package:flutter_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/fcm_notification_service.dart';

import 'buttons.dart';
import 'state_widgets.dart';

class TaskSheet extends StatefulWidget {
  final int? categoryId;
  final bool isUpdate;
  final Event? event;

  const TaskSheet({Key? key, this.event, this.categoryId, this.isUpdate = false})
      : super(key: key);

  @override
  _TaskSheetState createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final TextEditingController _textController = TextEditingController();
  final CollectionReference _tokensDB =
  FirebaseFirestore.instance.collection('token');
  final FCMNotificationService _fcmNotificationService =
  FCMNotificationService();

  late String _otherDeviceToken;

  Event? event;
  EventCategory? category;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int? selectedCategory = widget.categoryId ?? null;
  DateTime? datePicked;
  TimeOfDay? timePicked;
  List<EventCategory>? cats = [];
  Client? owner;
  double _currentSliderValue = 1000;
  List<Client> clients = [];
  List<Client> selectedClients = [];
  List<Client> invitedClient = [];
  List<int> clientsId = [];
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 3),
        () => 'Data Loaded',
  );

  getData() async {
    cats = await EventCategory.fetchData();
    clients = await Client.fetchData();
    if(event!=null) {
      invitedClient = await Client.fetchByEvent(event!.id!);
    }
    for (var cl in invitedClient) {
      clientsId.add(cl.id!);
    }
    if(widget.categoryId!=null){
      category = await EventCategory.fetchCatById(widget.categoryId!);
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
      owner = await Client.fetchClient(preferences.getInt('currentId')!);
    clients.removeWhere((element) => element.id==owner!.id);
  }

  @override
  void initState() {
    getData();
    if (widget.isUpdate) {
      event = widget.event!;
      // categoryItem = widget.task!.taskCategoryItemEntity;
      titleController = TextEditingController(text: event!.title);
      descriptionController = TextEditingController(text: event!.description);
      addressController = TextEditingController(text: event!.address);
      selectedCategory = event!.category.id;
      datePicked = event!.startTime;
      if(event!.budget!=null) {
        _currentSliderValue = event!.budget!;
      }
      timePicked = event?.startTime != null
          ? TimeOfDay.fromDateTime(event!.startTime!)
          : null;
    } else {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
    }
    super.initState();

    load();
  }

  Future<void> load() async {
    //Request permission from user.
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }

    //Fetch the fcm token for this device.
    String? token = await _fcm.getToken();

    //Validate that it's not null.
    assert(token != null);

    //Determine what device we are on.
    late String thisDevice;
    late String otherDevice;

    if (Platform.isIOS) {
      thisDevice = 'iOS';
      otherDevice = 'Android';
    } else {
      thisDevice = 'Android';
      otherDevice = 'Other';
    }

    //Update fcm token for this device in firebase.
    DocumentReference docRef = _tokensDB.doc(thisDevice);
    docRef.set({'token': token});

    //Fetch the fcm token for the other device.
    DocumentSnapshot docSnapshot = await _tokensDB.doc(otherDevice).get();
    _otherDeviceToken = docSnapshot['token'];
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  _deleteTask() {
    showDialog<bool>(
      context: context,
      builder: (context) => FilterWrapper(
        blurAmount: 5,
        child: AlertDialog(
          title: Text("Удалить событие?", style: AppTheme.eventPanelHeadline),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GarbageWidget(),
              SizedBox(height: 20),
              Text(
                'Вы уверены, что хотите удалить событие?',
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
                Event.deleteEvent(event!);
                Helper.showCustomSnackBar(
                  context,
                  content: 'Событие успешно удалено',
                  bgColor: AppTheme.purpleDark,
                );
                Navigator.pop(context, true);
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

  _sendPush(token, title) async {
    try {
      await _fcmNotificationService.sendNotificationToUser(
        title: 'Новое приглашение!',
        body: '${owner!.name} пригласил(а) Вас на мероприятие:  $title',
        fcmToken: token,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Уведомление отправлено'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error, ${e.toString()}.'),
        ),
      );
    }
  }

  _updateTask() {
    if (_formKey.currentState!.validate()) {
      Event eventItemEntity = Event(
        id: event!.id,
        title: titleController.text,
        description: descriptionController.text,
        category: cats![selectedCategory!-1],
        address: addressController.text,
        budget: _currentSliderValue,
        owner: owner!
      );
      if (datePicked != null) {
        final DateTime savedDeadline = DateTime(
          datePicked!.year,
          datePicked!.month,
          datePicked!.day,
          timePicked != null ? timePicked!.hour : DateTime.now().hour,
          timePicked != null ? timePicked!.minute : DateTime.now().minute,
        );
        eventItemEntity = Event(
          id: event!.id,
          title: titleController.text,
          description: descriptionController.text,
          category: cats![selectedCategory!-1],
          address: addressController.text,
          budget: _currentSliderValue,
          startTime: savedDeadline.toLocal(),
          owner: owner!
        );
      }
      Event.updateEvent(eventItemEntity);
      selectedClients.add(owner!);
      Client.invite(selectedClients, eventItemEntity).then((value) => print(value.statusCode));
      for (var cl in selectedClients) {
        _sendPush(cl.social, eventItemEntity.title);
      }
      Helper.showCustomSnackBar(
        context,
        content: 'Событие успешно обновлено',
        bgColor: AppTheme.purpleDark,
      );
      Navigator.pop(context);
    }
  }

  _saveTask() {
    if (_formKey.currentState!.validate()) {
      Event eventItemEntity = Event(
          // id: event!.id ?? 0,
          title: titleController.text,
          description: descriptionController.text,
          category: cats![selectedCategory!-1],
          address: addressController.text,
          budget: _currentSliderValue,
          owner: owner!
      );
      if (datePicked != null) {
        final DateTime savedDeadline = DateTime(
          datePicked!.year,
          datePicked!.month,
          datePicked!.day,
          timePicked != null ? timePicked!.hour : DateTime.now().hour,
          timePicked != null ? timePicked!.minute : DateTime.now().minute,
        );
        eventItemEntity = Event(
            // id:  event!.id ?? 0,
            title: titleController.text,
            description: descriptionController.text,
            category: cats![selectedCategory!-1],
            address: addressController.text,
            budget: _currentSliderValue,
            startTime: savedDeadline,
            owner: owner!
        );
      }
      // Event.addEvent(eventItemEntity).then((value) => print(value.statusCode));
      selectedClients.add(owner!);
      Client.invite(selectedClients, eventItemEntity).then((value) => print(value.statusCode));
      Helper.showCustomSnackBar(
        context,
        content: 'Событие добавлено',
        bgColor: AppTheme.purplePink.lighter(30),
      );
      setState(() {
      });
      Navigator.pop(context);
    }
  }

  _getDate() async {
    Helper.unfocus();
    final picked = await Helper.showDeadlineDatePicker(
      context,
      datePicked ?? DateTime.now(),
    );
    if (picked != null && picked != datePicked) {
      setState(() {
        datePicked = picked;
      });
    }
  }

  _getTime() {
    Helper.unfocus();
    Helper.showDeadlineTimePicker(
      context,
      timePicked ?? TimeOfDay.now(),
      onTimeChanged: (TimeOfDay timeOfDay) {
        if (timeOfDay != timePicked) {
          setState(() {
            timePicked = timeOfDay;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _calculation,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.hasData) {
        return Material(
          child: SafeArea(
            top: false,
            child: Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        widget.isUpdate
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Image.asset(
                                Resources.deleteImage,
                                height: 20,
                                width: 20,
                              ),
                              onTap:
                                _deleteTask
                            ),
                            Text('Обновить событие',
                                style: AppTheme.mainPageHeadline),
                            GestureDetector(
                              child: SvgPicture.asset(
                                Resources.complete,
                                height: 20,
                                width: 20,
                              ),
                              onTap: _updateTask,
                            ),
                          ],
                        )
                            : Center(
                          child: Text('Добавить событие',
                              style: AppTheme.mainPageHeadline),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: AppTheme.eventPanelHeadline.withBlack,
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Название',
                            hintStyle: AppTheme.hintsText,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide(
                                color: AppTheme.borderPurple
                              )
                            )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите название';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: AppTheme.eventPanelHeadline.withBlack,
                          controller: addressController,
                          decoration: InputDecoration(
                            hintText: 'Адрес',
                            hintStyle: AppTheme.hintsText,
                          border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(
                                color: AppTheme.borderPurple
                            )
                        )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите адрес';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: AppTheme.eventPanelHeadline.withBlack,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Описание',
                            hintStyle: AppTheme.hintsText,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(
                                      color: AppTheme.borderPurple
                                  )
                              )
                          ),
                          maxLines: 5,
                          scrollPhysics: BouncingScrollPhysics(),
                        ),
                        SizedBox(height: 20),
                        Slider(
                          value: _currentSliderValue,
                          max: 1000000,
                          activeColor: AppTheme.bottomAddSheetDate,
                          inactiveColor: AppTheme.bottomAddSheetDate,
                          divisions: 500,
                          label: _currentSliderValue.toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                          },
                        ),
                        Text('Бюджет', style: AppTheme.hintsText,),
                        SizedBox(height: 20),
                        ElevatedButton(
                            child: Text('Пригласить гостей'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppTheme.bottomAddSheetDate)
                            ),
                            onPressed: () async {
                              selectedClients = await showDialog<List<Client>>(
                                  context: context,
                                  builder: (_) => MultiSelectDialog(
                                      question: Text('Выберете пользователей'),
                                      answers: clients,
                                      invitedClient: clientsId)) ??
                                  [];
                              print(selectedClients);
                      // Logic to save selected flavours in the database
                        }),
                        SizedBox(height: 20),
                        Row(children: [
                          Expanded(
                            child: RippleButton(
                              onTap: _getDate,
                              text: datePicked != null
                                  ? datePicked!
                                  .format(FormatDate.monthDayYear)
                                  : 'Дата',
                              prefixWidget: SvgPicture.asset(
                                  Resources.date,
                                  color: Colors.white,
                                  width: 16),
                              suffixWidget: datePicked != null
                                  ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    datePicked = null;
                                  });
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: RippleButton(
                              onTap: _getTime,
                              text: timePicked != null
                                  ? timePicked!.format(context)
                                  : 'Время',
                              prefixWidget: SvgPicture.asset(
                                  Resources.clock,
                                  color: Colors.white,
                                  width: 16),
                              suffixWidget: timePicked != null
                                  ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    timePicked = null;
                                  });
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                                  : null,
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        cats!=null
                            ? DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            hintText: 'Выберите категорию',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(
                                      color: AppTheme.borderPurple
                                  )
                              )
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Выберете категорию';
                            }
                            return null;
                          },
                          onTap: () => Helper.unfocus(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          items: cats!
                              .map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(e.title),
                            );
                          }).toList(),
                          style: AppTheme.eventPanelHeadline.withBlack,
                          value: selectedCategory,
                        )
                            : Container(),
                        SizedBox(height: 20),
                        if((widget.isUpdate && widget.event!.owner.id == owner!.id) || (!widget.isUpdate))
                        PinkButton(
                          text: widget.isUpdate
                              ? 'Обновить'
                              : 'Сохранить',
                          onTap:
                          widget.isUpdate ? _updateTask : _saveTask,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      else {
        return LoadingWidget();
      }
      },
    );
  }
}
