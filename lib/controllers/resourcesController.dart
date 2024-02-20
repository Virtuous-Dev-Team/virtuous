import 'package:get/get.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/resources.dart';

part 'resourcesController.g.dart';

@riverpod
class ResourcesController extends _$ResourcesController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> getResources(String communityName) async {
    try {
      final resourcesRepo = ref.read(resourcesRepositoryProvider);
      state = const AsyncLoading();
      final result = await AsyncValue.guard(
          () => resourcesRepo.resourcesMyCommunityInfo(communityName));
      if (result.value['Success']) {
        print('caloled resources controller, result: $result');
        final Map<String, dynamic> mappy = result.value['response'];
        // state = AsyncData(result.value['response']);
        state = AsyncData(mappy);

        print(mappy);
      } else {
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}
