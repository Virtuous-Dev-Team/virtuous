import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/communityCreation.dart';

part 'communityCreationController.g.dart';

@riverpod
class CommunityCreationController extends _$CommunityCreationController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> getCommunityNames() async {
    try {
      final provider = ref.read(communityCreationProvider);
      final result = await AsyncValue.guard(
          () => provider.getCommunityNames());
      if (result.value['Success']) {
        print(
            'community list : ${result.value['response']}');
        state = AsyncData({
          'Function': "getCommunityNames",
          "communityList": result.value['response']
        });
       
      } else {
        final error = {
          'Function': 'getCommunityNames',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    }catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

}
