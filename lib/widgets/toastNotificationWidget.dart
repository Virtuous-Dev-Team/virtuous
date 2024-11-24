import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastNotificationWidget {
  Toastification toasty = Toastification();

  ToastificationItem successOrError(context, message, notificationType) {
    return toasty.show(
      context: context,
      showProgressBar: false,
      type: notificationType
          ? ToastificationType.success
          : ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: message,
      //title: Text(message),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
