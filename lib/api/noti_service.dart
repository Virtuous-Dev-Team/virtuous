import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

}
