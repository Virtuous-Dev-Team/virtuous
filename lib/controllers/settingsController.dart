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

  Future<void> updatePassword(String newPassword) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(
          () => settingsRepo.updatePassword(newPassword));

      if (result.value['Success']) {
        state = AsyncData('Password updated successfully');
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
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

  Future<void> updateProfile(String newEmail, String newProfileName,
      String newCareer, String newCommunity, String newCareerLength) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(() => settingsRepo.updateProfile(
          newEmail, newProfileName, newCareer, newCommunity, newCareerLength));

      if (result.value['Success']) {
        state = AsyncData('Profile preferences updated successfully');
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
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

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final result = await AsyncValue.guard(
          () => settingsRepo.updatePhoneNumber(newPhoneNumber));

      if (result.value['Success']) {
        state = AsyncData('Phone number updated successfully');
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
