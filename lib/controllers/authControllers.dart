import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

// 2. declare a part file
// part 'authControllers.g.dart';

class AuthController extends StateNotifier<AsyncValue<dynamic>> {
  AuthController(this.ref) : super(const AsyncData(null));
  final Ref ref;
  Future signIn(email, password) async {
    final authRepository = ref.read(authRepositoryProvider);
    try {
      print('calling get auth controller');
      state = const AsyncLoading();
      final result = await AsyncValue.guard(
          () => authRepository.signInUser(email, password));
      print(result);
      if (result.value['Success']) {
        state = AsyncData(result.value['response']);

        // print(
        //     "returning list from recen entries controller ${result.value['response']}");
      } else {
        print("faild sign in ${result.value['Error']}");
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
      return Future(() => "null");
      // This line sets the state to the result of the asynchronous operation.
    } catch (error) {
      print('Error in UserRecentEntriesController: $error');
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<dynamic>>((ref) {
  return AuthController(ref);
});
