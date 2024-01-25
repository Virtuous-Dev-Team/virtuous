import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communities.dart';

class CommunitiesController extends AsyncNotifier<dynamic> {
  @override
  FutureOr<void> build() {
    // TODO: implement build
    return getQuadrantListy();
  }

  Future<void> getQuadrantListy() async {
    try {
      final communitiesRepo = ref.read(communitiesRepositoryProvider);
      print('calling get controllers');
      final result = await AsyncValue.guard(
          () => communitiesRepo.getQuadrantList("legal"));

      state = result.value;
      print(result
          .value); // This line sets the state to the result of the asynchronous operation.
    } catch (error) {}
  }
}

final communitiesControllerProvider =
    AsyncNotifierProvider<CommunitiesController, dynamic>(() {
  return CommunitiesController();
});
