import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:virtuetracker/api/users.dart';

class UserRecentEntriesController
    extends FamilyAsyncNotifier<dynamic, ({String communityName})> {
  @override
  FutureOr<void> build(arg) async {
    // TODO: implement build
    getMostRecentEntries(arg.communityName);
  }

  Future<void> getMostRecentEntries(String communityName) async {
    try {
      final userRepo = ref.read(usersRepositoryProvider);
      state = const AsyncLoading();
      final result = await AsyncValue.guard(
          () => userRepo.getMostRecentEntries(communityName));
      // print(result.value['response']);
      if (result.value['Success']) {
        state = AsyncData(result.value['response']);

        // print(
        //     "returning list from recen entries controller ${result.value['response']}");
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
      // This line sets the state to the result of the asynchronous operation.
    } catch (error) {
      print('Error in UserRecentEntriesController: $error');
      state = AsyncError(error, StackTrace.current);
    }
  }
}

// final UserRecentEntriesControllerProvider =
//     AsyncNotifierProvider<UserRecentEntriesController, dynamic>(() {
//   return UserRecentEntriesController();
// });
final entries = Provider<UserRecentEntriesController>((ref) {
  return UserRecentEntriesController();
});
final UserRecentEntriesControllerProvider = AsyncNotifierProvider.family<
    UserRecentEntriesController,
    dynamic,
    ({String communityName})>(UserRecentEntriesController.new);
