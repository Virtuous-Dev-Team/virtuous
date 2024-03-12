import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/settings.dart';

part 'settingsController.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> updatePassword(
      {required String newPassword, required Function authError}) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(() => settingsRepo.updatePassword(
          newPassword: newPassword, authError: authError));

      if (result.value['Success']) {
        state = AsyncData({
          'Function': "updatePassword",
          "msg": 'Password updated successfully!'
        });
      } else {
        final error = {
          'Function': 'updatePassword',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> updatePrivacy(
      bool newShareEntries, bool newShareLocation) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(
          () => settingsRepo.updatePrivacy(newShareEntries, newShareLocation));

      if (result.value['Success']) {
        state = AsyncData('Privacy preferences updated successfully');
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> updateProfile(
      {required String newEmail,
      required String newProfileName,
      required String newCareer,
      required String newCommunity,
      required String newCareerLength,
      required Function authError}) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(() => settingsRepo.updateProfile(
          newEmail,
          newProfileName,
          newCareer,
          newCommunity,
          newCareerLength,
          authError));

      if (result.value['Success']) {
        state = AsyncData({
          'Function': "updateProfile",
          "msg": 'Profile preferences updated successfully'
        });
      } else {
        final error = {
          'Function': 'updateProfile',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> updateNotificationPreferences(
      bool newAllowNotificationa, String newNotificationTime) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(() =>
          settingsRepo.updateNotificationPreferences(
              newAllowNotificationa, newNotificationTime));

      if (result.value['Success']) {
        state = AsyncData('Notification preferences updated successfully');
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> updatePhoneNumber(
      String newPhoneNumber, Function errorStep, Function nextStep) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(() =>
          settingsRepo.updatePhoneNumber(
              newPhoneNumber: newPhoneNumber,
              errorStep: errorStep,
              nextStep: nextStep));

      if (result.value['Success']) {
        state = AsyncData({
          'Function': "updatePhoneNumber",
          "msg": 'Phone Number updated successfully!'
        });
      } else {
        final error = {
          'Function': 'updatePhoneNumber',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> reauthenticateUser(String email, String password) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(
          () => settingsRepo.reauthenticateUser(email, password));

      if (result.value['Success']) {
        state = AsyncData({
          'Function': "reauthenticateUser",
          "msg":
              'Account authenticated successfully, you can now finish updating your profile!'
        });
      } else {
        final error = {
          'Function': 'reauthenticateUser',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
