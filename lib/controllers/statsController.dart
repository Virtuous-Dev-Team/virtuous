import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/stats.dart';

part 'statsController.g.dart';

@riverpod
class StatsController extends _$StatsController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> getQuadrantsUsedList(String communityName) async {
    try {
      final statsRepository = ref.read(statsRepositoryProvider);
      // state = const AsyncLoading();

      final result = await AsyncValue.guard(
          () => statsRepository.getQuadrantsUsedList(communityName));
      // print('calling stats controller ${result.value['response']}');
      if (result.value['Success']) {
        state = AsyncData({
          'Function': "getQuadrantsUsedList",
          "response": result.value['response']
        });
        // ref.refresh(UserRecentEntriesControllerProvider);
      } else {
        final error = {
          'Function': 'getQuadrantsUsedList',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> buildCalendar() async {
    try {
      final statsRepository = ref.read(statsRepositoryProvider);
      state = const AsyncLoading();

      final result =
          await AsyncValue.guard(() => statsRepository.buildCalendar());
      if (result.value['Success']) {
        print(
            'calling stats controller calendar func${result.value['response']}');

        state = AsyncData({
          'Function': "buildCalendar",
          "response": result.value['response']
        });
        // ref.refresh(UserRecentEntriesControllerProvider);
      } else {
        final error = {
          'Function': 'buildCalendar',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> getAllStats(String communityName) async {
    try {
      final statsRepository = ref.read(statsRepositoryProvider);
      print('callint getallstats!!!');
      final result = await AsyncValue.guard(
          () => statsRepository.getAllStats(communityName));
      final success = result.value['Success'];
      print('get all stats ${success[0]}');
      if (success[0] && success[1]) {
        state = AsyncData({
          'success': success,
          'quadrantList': result.value['quadrantLists'],
          "calendarData": result.value['calendar']
        });
      } else {
        final error = {
          'Function': 'getAllStats',
          'msg': 'Error loading calendar and stats'
        };

        state = AsyncError(error, StackTrace.current);
      }
      // if (result.value['Success']) {
      //   print('calling stats controller ${result.value['response']}');

      //   state = AsyncData({
      //     'Function': "buildCalendar",
      //     "response": result.value['response']
      //   });
      //   // ref.refresh(UserRecentEntriesControllerProvider);
      // } else {
      //   final error = {
      //     'Function': 'buildCalendar',
      //     'msg': result.value['Error']
      //   };

      //   state = AsyncError(error, StackTrace.current);
      // }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
