import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/stats.dart';
import 'package:virtuetracker/api/users.dart';

class PieChartController
    extends FamilyAsyncNotifier<dynamic, ({String communityName})> {
  @override
  FutureOr<void> build(arg) async {
    // TODO: implement build
    getQuadrantsUsedList(arg.communityName);
  }

  Future<void> getQuadrantsUsedList(String communityName) async {
    try {
      final statsRepo = ref.read(statsRepositoryProvider);
      state = const AsyncLoading();
      final result = await AsyncValue.guard(
          () => statsRepo.getQuadrantsUsedList(communityName));
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
      print('Error in PieChartController: $error');
      state = AsyncError(error, StackTrace.current);
    }
  }
}

// final PieChartControllerProvider =
//     AsyncNotifierProvider<PieChartController, dynamic>(() {
//   return PieChartController();
// });

final PieChartControllerProvider = AsyncNotifierProvider.family<
    PieChartController,
    dynamic,
    ({String communityName})>(PieChartController.new);
