import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class UserInfoe {
//   final String id;
//   final String email;
//   final String displayName;
//   final String currentCommunity;
//   final String currentPosition;
//   final String careerLength;

//   UserInfoe({
//     required this.id,
//     required this.email,
//     required this.displayName,
//     required this.currentCommunity,
//     required this.currentPosition,
//     required this.careerLength,
//   });

// }
// class UserInfoProvider extends ChangeNotifier {
//   late String _id;
//   late String _email;
//   late String _displayName;
//   late String _currentCommunity;
//   late String _currentPosition;
//   late String _careerLength;

//   String get id => _id;
//   String get email => _email;
//   String get displayName => _displayName;
//   String get currentCommunity => _currentCommunity;
//   String get currentPosition => _currentPosition;
//   String get careerLength => _careerLength;

//   void setUserInfo({
//     required String id,
//     required String email,
//     required String displayName,
//     required String currentCommunity,
//     required String currentPosition,
//     required String careerLength,
//   }) {
//     _id = id;
//     _email = email;
//     _displayName = displayName;
//     _currentCommunity = currentCommunity;
//     _currentPosition = currentPosition;
//     _careerLength = careerLength;

//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  late Map<String, dynamic> _quadrantUsedData;
  late String _reasons;
  late bool _shareEntries;
  late String _currentCommunity;
  late bool _shareLocation;
  late GeoPoint _userLocation;
  late NotificationPreferences _notificationPreferences;
  late CareerInfo _careerInfo;

  Map<String, dynamic> get quadrantUsedData => _quadrantUsedData;
  String get reasons => _reasons;
  bool get shareEntries => _shareEntries;
  String get currentCommunity => _currentCommunity;
  bool get shareLocation => _shareLocation;
  GeoPoint get userLocation => _userLocation;
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
        GeoPoint(0, 0); // Assuming GeoPoint has constructor
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
