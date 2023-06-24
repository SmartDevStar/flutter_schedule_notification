import 'package:flutter/material.dart';
import 'package:schedulenotification/services/notification_service.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NotificationApi notificationApi;
  DateTime scheduleTime = DateTime.now();
  int _counter = 0;

  void _incrementCounter() {
    tz.TZDateTime timeZoneDateTime = tz.TZDateTime.from(scheduleTime, tz.local);
    print(timeZoneDateTime);
    notificationApi.showScheduledNotification(
      id: 289,
      title: 'Scheduled Notification',
      body: '$scheduleTime',
      date: timeZoneDateTime,
      payload: "",
    );
    notificationApi.showScheduledNotification(
      id: 291,
      title: 'Scheduled Notification',
      body: '$scheduleTime',
      date: timeZoneDateTime.add(const Duration(minutes: 5)),
      payload: "",
    );
    notificationApi.showScheduledNotification(
      id: 293,
      title: 'Scheduled Notification',
      body: '$scheduleTime',
      date: timeZoneDateTime.add(const Duration(minutes: 5)),
      payload: "",
    );
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    notificationApi = NotificationApi();
    notificationApi.initApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  picker.DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true, 
                    onChanged: (date) {
                      scheduleTime = date;
                    }, 
                    onConfirm: (date) {
                      scheduleTime = date;
                      print('confirm $scheduleTime');
                    }, 
                    currentTime: DateTime.now(),
                  );
                },
                child: const Text(
                  'show date time',
                  style: TextStyle(color: Colors.blue),
                )),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
