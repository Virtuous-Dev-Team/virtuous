import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  late Map<String, dynamic> _quadrantUsedData;
  late String _reasons;
  late bool _shareEntries;
  late String _currentCommunity;
  late bool _shareLocation;
  late dynamic _userLocation;
  late NotificationPreferences _notificationPreferences;
  late CareerInfo _careerInfo;

  Map<String, dynamic> get quadrantUsedData => _quadrantUsedData;
  String get reasons => _reasons;
  bool get shareEntries => _shareEntries;
  String get currentCommunity => _currentCommunity;
  bool get shareLocation => _shareLocation;
  dynamic get userLocation => _userLocation;
  NotificationPreferences get notificationPreferences =>
      _notificationPreferences;
  CareerInfo get careerInfo => _careerInfo;

  void setUserInfo(Map<String, dynamic> response) {
    _quadrantUsedData = response['quadrantUsedData'] ?? '';
    _reasons = response['reasons'] ?? '';
    _shareEntries = response['shareEntries'] ?? false;
    _currentCommunity = response['currentCommunity'] ?? '';
    _shareLocation = response['shareLocation'] ?? false;
    _userLocation = response['userLocation'] ??
        []; // Assuming GeoPoint has constructor
    _notificationPreferences =
        NotificationPreferences.fromJson(response['notificationPreferences']);
    _careerInfo = CareerInfo.fromJson(response['careerInfo']);

    notifyListeners();
  }
}

class NotificationPreferences {
  final bool allowNotifications;
  final String notificationTime;
  final bool phoneVerified;
  final String? fcmToken;

  NotificationPreferences({
    required this.allowNotifications,
    required this.notificationTime,
    required this.phoneVerified,
    this.fcmToken,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      allowNotifications: json['allowNotifications'] ?? false,
      notificationTime: json['notificationTime'] ?? '',
      phoneVerified: json['phoneVerified'] ?? false,
      fcmToken: json['fcmToken'],
    );
  }
}

class CareerInfo {
  final String currentPosition;
  final String careerLength;

  CareerInfo({
    required this.currentPosition,
    required this.careerLength,
  });

  factory CareerInfo.fromJson(Map<String, dynamic> json) {
    return CareerInfo(
      currentPosition: json['currentPosition'] ?? '',
      careerLength: json['careerLength'] ?? '',
    );
  }
}

final userInfoProviderr = ChangeNotifierProvider((ref) => UserInfoProvider());
