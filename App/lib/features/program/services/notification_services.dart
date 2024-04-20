import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestSoundPermission: true,
            requestBadgePermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin, // Note the change to Darwin settings
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // This is where you can show a dialog or navigate the user to a different screen based on the notification details.
    // showDialog(
    //   context: context, // Make sure to pass your BuildContext correctly
    //   builder: (BuildContext context) => AlertDialog(
    //     title: Text(title ?? ''),
    //     content: Text(body ?? ''),
    //     actions: <Widget>[
    //       TextButton(
    //         child: Text('Ok'),
    //         onPressed: () {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           // Optionally navigate to a different screen
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    // Handle the user's interaction with the notification
    // You can use the response.payload to decide what to do
    if (response.payload != null) {
      // Navigate to the desired screen or perform actions based on payload
    }
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}
