import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/users.dart';

import '../Models/VirtueEntryModels.dart';

part 'virtueEntryController.g.dart';

@riverpod
class VirtueEntryController extends _$VirtueEntryController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> addEntry(
    String communityName,
    String quadrantUsed,
    String quadrantColor,
    bool shareLocation,
    bool shareEntry,
    String sleepHours,
    String adviceAnswer,
    String whatHappenedAnswer,
    List<Events> eventList,
    List<Events> whoWereWithYouList,
    List<Events> whereWereYouList,
    String dateAndTimeOfOccurence,
  ) async {
    try {
      final usersRepo = ref.read(usersRepositoryProvider);
      final result = await AsyncValue.guard(() => usersRepo.addEntry(
            communityName,
            quadrantUsed,
            quadrantColor,
            shareLocation,
            shareEntry,
            sleepHours,
            adviceAnswer,
            whatHappenedAnswer,
            eventList,
            whoWereWithYouList,
            whereWereYouList,
            dateAndTimeOfOccurence,
          ));

      if (result.value['Success']) {
        state = AsyncData(
            {'Function': "addEntry", "msg": 'Successfully added your entry!'});
        // ref.refresh(UserRecentEntriesControllerProvider);
      } else {
        final error = {'Function': 'addEntry', 'msg': result.value['Error']};

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> getMostRecentEntries(
    String communityName,
  ) async {
    try {
      final usersRepo = ref.read(usersRepositoryProvider);
      final result = await AsyncValue.guard(
          () => usersRepo.getMostRecentEntries(communityName));

      if (result.value['Success']) {
        print(
            'recent list virtue entry controller: ${result.value['response']}');
        state = AsyncData({
          'Function': "getMostRecentEntries",
          "list": result.value['response']
        });
        // ref.refresh(UserRecentEntriesControllerProvider);
      } else {
        final error = {
          'Function': 'getMostRecentEntries',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
