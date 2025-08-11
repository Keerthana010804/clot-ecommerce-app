import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_commerce/widgets/custom_widgets.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    if (kIsWeb) {
      // Optional: Inform the user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Web notifications are limited or unsupported in some browsers."),
          ),
        );
      });
      return;
    }

    // Native platforms (Android/iOS)
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for test alerts',
          defaultColor: Colors.teal,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  void showSampleNotification() {
    if (kIsWeb) {
      // Show an info message since Awesome Notifications doesn't support web
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notifications are not supported on Web.")),
      );
      return;
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: '🔔 Hello!',
        body: 'This is your sample notification.',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(context, 1),
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: showSampleNotification,
          child: const Text('Show Sample Notification'),
        ),
      ),
    );
  }
}
