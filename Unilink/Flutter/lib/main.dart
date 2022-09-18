import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/configs/routers_config.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/view_model/address_view_model.dart';
import 'package:unilink_flutter_app/view_model/auth_view_model.dart';
import 'package:unilink_flutter_app/view_model/firebase_init.dart';
import 'package:unilink_flutter_app/view_model/google_map_view_model.dart';
import 'package:unilink_flutter_app/view_model/group_view_model.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/message_view_model.dart';
import 'package:unilink_flutter_app/view_model/notify_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/post_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/view_model/swipe_card_view_model.dart';
import 'package:unilink_flutter_app/view_model/topic_view_model.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FireBaseInit()),
          ChangeNotifierProvider(create: (context) => GroupViewModel()),
          ChangeNotifierProvider(create: (context) => AuthViewModel()),
          ChangeNotifierProvider(create: (context) => NotifyViewModel()),
          ChangeNotifierProvider(
              create: (context) => UniversityListViewModel()),
          ChangeNotifierProvider(create: (context) => PostListViewModel()),
          ChangeNotifierProvider(create: (context) => MessageViewModel()),
          ChangeNotifierProvider(create: (context) => SkillListViewModel()),
          ChangeNotifierProvider(create: (context) => MajorListViewModel()),
          ChangeNotifierProvider(create: (context) => FeedbackPosition()),
          ChangeNotifierProvider(create: (context) => GoogleMapViewModel()),
          ChangeNotifierProvider(create: (context) => PartyListViewModel()),
          ChangeNotifierProvider(create: (context) => MemberListViewModel()),
          ChangeNotifierProvider(create: (context) => AddressViewModel()),
          ChangeNotifierProvider(create: (context) => TopicListViewModel()),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primarySwatch: Colors.blue,
            ),
            initialRoute: SPLASH_ROUTE,
            onGenerateRoute: RouterGenerator.generateRoute));
  }
}
