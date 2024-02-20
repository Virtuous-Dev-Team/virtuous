import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/users.dart';

// 2. declare a part file
part 'surveyPageController.g.dart';

@riverpod
class SurveyPageController extends _$SurveyPageController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> surveyInfo(
      String currentPosition,
      String careerLength,
      String currentCommunity,
      String reason,
      bool shareEntries,
      bool shareLocation,
      bool allowNotifications,
      String phoneNumber,
      String notificationTime,
      bool phoneVerified,
      GeoPoint userLocation) async {
    try {
      final userRepository = ref.read(usersRepositoryProvider);
      state = const AsyncLoading();
      final result = await AsyncValue.guard(() => userRepository.surveyInfo(
          currentPosition,
          careerLength,
          currentCommunity,
          reason,
          shareEntries,
          shareLocation,
          allowNotifications,
          phoneNumber,
          notificationTime,
          phoneVerified,
          userLocation));
      if (result.value['Success']) {
        state = AsyncData('/survey/tutorial');
      }

      // print(
      //     "returning list from recen entries controller ${result.value['response']}");
      else {
        print("failed survey ${result.value['Error']}");
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> getLocation() async {
    try {
      final userRepository = ref.read(usersRepositoryProvider);
      state = const AsyncLoading();
      final result =
          await AsyncValue.guard(() => userRepository.addUserLocation());
      if (result.value['Success']) {
        state = AsyncData(result.value['response']);
      } else {
        print("failed getting location ${result.value['Error']}");
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> sendOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      final userRepository = ref.read(usersRepositoryProvider);
      state = const AsyncLoading();
      final result = await AsyncValue.guard(() => userRepository.sendOtp(
          phone: phone, errorStep: errorStep, nextStep: nextStep));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> confrimOtp({
    required String otp,
  }) async {
    try {
      final userRepository = ref.read(usersRepositoryProvider);
      state = const AsyncLoading();
      final result =
          await AsyncValue.guard(() => userRepository.confirmOtp(otp: otp));

      if (result.value['Success']) {
        state = AsyncData(true);
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
