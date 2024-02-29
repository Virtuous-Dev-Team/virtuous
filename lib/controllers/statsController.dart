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
      state = const AsyncLoading();

      final result = await AsyncValue.guard(
          () => statsRepository.getQuadrantsUsedList(communityName));
      print('calling stats controller ');
      if (result.value['Success']) {
        state = AsyncData(result.value['response']);
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
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
        state = AsyncData(result.value['response']);
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
