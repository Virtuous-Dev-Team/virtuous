import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

// Tried implementing notifications but didn't work
class NotificationService {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();

    bool _isInitialized = false;

    bool get isInitialized => _isInitialized;

    // initialization called in main
    Future<void> initNotification() async {
        if (_isInitialized) return; // prevent re-initialization

        // android initialization
        const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher_foreground');

        // ios initialization
        const initSettingsIOS = DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true
        );

        // init settings
        const initSettings = InitializationSettings(
            android: initSettingsAndroid,
            iOS: initSettingsIOS
        );

        // init plugin
        await notificationsPlugin.initialize(initSettings);

    }

    Future<void> handleNotification(bool allowNotifications, DateTime notificationTime) async {
      FlutterLocalNotificationsPlugin notiPlugin = FlutterLocalNotificationsPlugin(); 

      // User has enabled notifications or is updating noti time
      if (allowNotifications) {

        // Converting DateTime to TZDateTime for zoneSchedule function
        tz.initializeTimeZones();
        final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
        TZDateTime usableTime = TZDateTime.from(notificationTime, tz.local);

        print('your time zone is $currentTimeZone');
        print('your tz location is ${tz.local}');
        print('The specified noti time is ${usableTime.toString()}');

        // Cancel other notifications to prevent unintentional stacking
        await notiPlugin.cancelAll();

        // TODO: iOS notification details?
        // schedules notification
        await notiPlugin.zonedSchedule(
          0,
          'Be Virtuous!',
          'Dont forget to be virtuous',
          usableTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'daily_channel_id',
                'Reminders',
                importance: Importance.max,
                priority: Priority.high,
            )),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
        );
      } else {
        // User has turned off notifications and all notifications need to be cleared
        await notiPlugin.cancelAll();
      }
    }

}
