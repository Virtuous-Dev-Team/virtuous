import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/auth.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:virtuetracker/api/users.dart';

// 2. declare a part file
part 'authControllers.g.dart';

@riverpod
// Future<dynamic> signIn(SignInRef ref, String email, String password) async {
//   final authRepository = ref.read(authRepositoryProvider);
//   // state = const AsyncLoading();
//   print('calling  sign in controller ');
//   return AsyncError("Error in singindf", StackTrace.current);
//   final result = await AsyncValue.guard(
//       () => authRepository.signInUser("email", "password"));
//   print(result);
//   if (result.value['Success']) {
//     return result.value['response'];

//     // print(
//     //     "returning list from recen entries controller ${result.value['response']}");
//   } else {
//     print("faild sign in ${result.value['Error']}");
//     return AsyncError(result.value['Error'], StackTrace.current);
//   }
// }

class AuthController extends _$AuthController {
  @override
  FutureOr<dynamic> build() async {
    // return a value (or do nothing if the return type is void)
    // state = AsyncLoading();
    return;
  }

  Future<void> signIn(String email, String password) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);

      state = const AsyncLoading();
      final result = await AsyncValue.guard(
          () => authRepository.signInUser(email, password));
      print(result);

      if (result.value['Success']) {
        final isNewUser = await ref.read(usersRepositoryProvider).getUserInfo();
        if (isNewUser['Success']) {
          print('go to home page');
          state = AsyncData('/home');
        } else {
          print('User has no record in Users collection so go to survey page');
          state = AsyncData('/survey');
        }

        // print(
        //     "returning list from recen entries controller ${result.value['response']}");
      } else {
        print("faild sign in ${result.value['Error']}");
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);

      state = const AsyncLoading();
      final result = await AsyncValue.guard(() => authRepository.signOutUser());
      print(result);
      if (result.value['Success']) {
        print('trying to sign out withing controller');
        state = AsyncData('/signIn');
      } else {
        print("failed sign out ${result.value['Error']}");
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> createAccount(
      String email, String password, String fullName) async {
    try {
      final authRepository = ref.read(authRepositoryProvider);

      state = const AsyncLoading();
      final result = await AsyncValue.guard(
          () => authRepository.createAccount(email, password, fullName));
      print(result);
      if (result.value['Success']) {
        print('trying to create out withing controller');
        state = AsyncData('/signIn');
      } else {
        print("failed create accout ${result.value['Error']}");
        state = AsyncError(result.value['Error'], StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }
}

// class AuthController extends StateNotifier<AsyncValue<dynamic>> {
//   AuthController(this.ref) : super(const AsyncData(null));
//   final Ref ref;
//   Future signIn(email, password) async {
//     final authRepository = ref.read(authRepositoryProvider);
//     try {
//       print('calling get auth controller');
//       state = const AsyncLoading();
//       final result = await AsyncValue.guard(
//           () => authRepository.signInUser(email, password));
//       print(result);
//       if (result.value['Success']) {
//         state = AsyncData(result.value['response']);

//         // print(
//         //     "returning list from recen entries controller ${result.value['response']}");
//       } else {
//         print("faild sign in ${result.value['Error']}");
//         state = AsyncError(result.value['Error'], StackTrace.current);
//       }
//       return Future(() => "null");
//       // This line sets the state to the result of the asynchronous operation.
//     } catch (error) {
//       print('Error in UserRecentEntriesController: $error');
//     }
//   }
// }

// final authControllerProvider =
//     StateNotifierProvider<AuthController, AsyncValue<dynamic>>((ref) {
//   return AuthController(ref);
// });
