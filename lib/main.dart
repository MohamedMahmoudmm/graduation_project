
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_on_route/login/login_screen.dart';
import 'package:help_on_route/map/mapScreen.dart';
import 'package:help_on_route/notification.dart';
import 'package:help_on_route/shared/constant.dart';
import 'package:help_on_route/shared/dio_helper.dart';

import 'network/local/cache_helper.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{

  print("Handling a background message");
  print("Handling a background message");
  print("Handling a background message");
  if(message.notification!.title !='Helper')
  {requestData
  =message.notification!.title;
  }
  Notify.instantNotify(message.notification!.body!);

  Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();
  await Firebase.initializeApp();
  await DioHelper.init();
  await CacheHelper.init();
  // Dio dio =  Dio();
  // Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=29.23352216946053,30.808663442730904&destinations=29.235703871904306%2C,30.802620761096478&key=AIzaSyCgws2nMUNNny_p0wUgAH2u9q2bcdScon8");
  // print('nnnnnnnnnnn'+response.data);
  FirebaseMessaging.instance.getToken().then((value)
  {
    print('00000000'+value.toString());
  });
  FirebaseMessaging.onMessage.listen((event) {
    print('hellllllllllllllp');
    if(event.notification!.title !='Helper')
      {requestData
      =event.notification!.title;
      }

    Notify.instantNotify(event.notification!.body!);
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //FirebaseMessaging.onBackgroundMessage((message) => null;
  Widget widget;

  uId=CacheHelper.getData(key: 'uId');

  if(uId != null)
  {
    //print(uId);
    //print('from main');
    widget= MapScreen();
  }
  else
  {
    widget=LoginScreen();
  }
  //await TextPreferences.init();
  runApp( MyApp(
      startWidget:widget
  ));
  AwesomeNotifications().initialize(null,
      [NotificationChannel(
          channelKey: 'Help',
          channelGroupKey: 'hh',
          ledColor: Colors.brown,
          defaultColor: Colors.red,
          importance: NotificationImportance.High,
          channelName: 'Basic Notification',
          channelShowBadge: true,
          channelDescription: 'nnnnnn')]);
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  const MyApp({this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      //home: LoginScreen(),
      home: startWidget,
    );
  }
}

