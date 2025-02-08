import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/userFeedback.dart';

part 'userFeedbackController.g.dart';

@riverpod
class UserFeedbackController extends _$UserFeedbackController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if return type is void)
    return;
  }

  Future<void> sendFeedback(String feedbackType, String message) async {
    try {
      final provider = ref.read(userFeedbackProvider);
      final result = await AsyncValue.guard(
        () => provider.sendFeedback(feedbackType, message));

      if (result.value['Sucess']) {
        state = AsyncData({
          'Function': 'sendFeedback',
          'msg': result.value['response']
        });

      } else {
        final error = {
          'Function': 'sendFeedback',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }

    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}