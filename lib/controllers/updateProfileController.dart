import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/updateProfile.dart';


part 'updateProfileController.g.dart';

@riverpod
class UpdateProfileController extends _$UpdateProfileController{
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> updateProfile(
      {required String newEmail,
      required String newProfileName,
      required String newCareer,
      required String newCommunity,
      required String newCareerLength,
      required Function authError,
      required bool newListExist}) async {
    try {
      final updateProfileRepo = ref.read(updateProfileProvider);
      final result = await AsyncValue.guard(() => updateProfileRepo.updateProfile(
          newEmail,
          newProfileName,
          newCareer,
          newCommunity,
          newCareerLength,
          authError,
          newListExist));

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


  
}
