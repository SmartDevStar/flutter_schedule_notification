import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  final _localNotificationApi = FlutterLocalNotificationsPlugin();

  Future<void> initApi() async {
    tz.initializeTimeZones();

    _localNotificationApi
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    _localNotificationApi
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _localNotificationApi.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id_0',
      'Reminder',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: DefaultStyleInformation(true, true),
    );
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationApi.show(id, title, body, details);
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    required String payload,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationApi.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        date,
        tz.local,
      ),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> periodicallyShowNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationApi.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      details,
      payload: payload,
      androidAllowWhileIdle: true,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    print("Tapped!");
  }
}
