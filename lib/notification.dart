import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class Notify
{
  static Future<bool> instantNotify(String body)async
  {
    final AwesomeNotifications awesomeNotifications =AwesomeNotifications();
    return awesomeNotifications.createNotification(

        content: NotificationContent(

            id: Random().nextInt(100),
            channelKey: 'Help',
          locked: true,
          title: 'help',
          body: body,
        ),

      actionButtons: <NotificationActionButton>[
        NotificationActionButton(
            key: 'yes',
            label: 'Accept',

        ),
        NotificationActionButton(
            key: 'no',
            label: 'Disable',
          buttonType: ActionButtonType.DisabledAction,
          autoDismissible: true,
          //buttonType: ActionButtonType.DisabledAction,
        ),
      ],
    );
  }
}