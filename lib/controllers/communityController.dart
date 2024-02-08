import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communities.dart';

class CommunitiesController
    extends FamilyAsyncNotifier<dynamic, ({String communityName})> {
  @override
  FutureOr<void> build(arg) async {
    // TODO: implement build
    getQuadrantListy(arg.communityName);
  }

  Future<void> getQuadrantListy(String communityName) async {
    try {
      final communitiesRepo = ref.read(communitiesRepositoryProvider);
      print('calling get controllers');
      state = const AsyncLoading();
      final result = await AsyncValue.guard(
          () => communitiesRepo.getQuadrantList(communityName));
      print(result.value['response']);
      if (result.value['Success']) {
        state = AsyncData(result.value['response']);
        // state = result.value['response'];

        print(
            "returning list from communities controller ${result.value['response']}");
        print("returning list from communities controller ${state}");
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
      // This line sets the state to the result of the asynchronous operation.
    } catch (error) {
      print('Error in communityController: $error');
      state = AsyncError(error, StackTrace.current);
    }
  }
}

// final communitiesControllerProvider =
//     AsyncNotifierProvider<CommunitiesController, dynamic>(() {
//   return CommunitiesController();
// });
final communitiesControllerProvider = AsyncNotifierProvider.family<
    CommunitiesController,
    dynamic,
    ({String communityName})>(CommunitiesController.new);
