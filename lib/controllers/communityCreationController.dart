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
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> getVirtueNames(String communityName) async {
    try {
      final provider = ref.read(communityCreationProvider);
      final result = await AsyncValue.guard(
          () => provider.getVirtueNames(communityName));
      print(result);
      if (result.value['Success']) {
        print(
            'virtue list : ${result.value['response']}');
        
        state = AsyncData({
          'Function': "getVirtueNames",
          "virtueList": result.value['response']
        });
       
      } else {
        print ('you got error in controller : $result');
        final error = {
          'Function': 'getVirtueNames',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      print('unexpected virtue get error $error');
      state = AsyncError(error, StackTrace.current);
    }
  }
  
  Future<void> createNewCommunity(
    String communityName, String communityDesc) async {
    try {
      final provider = ref.read(communityCreationProvider);
      final result = await AsyncValue.guard(
          () => provider.createNewCommunity(communityName, communityDesc));
      if (result.value['Success']) {
        state = AsyncData({
          'Function': "createNewCommunity",
          "msg": result.value['response']
        });
       
      } else {
        final error = {
          'Function': 'createNewCommunity',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> editCommunityDesc(
    String currentCommunity, String communityDesc) async {
    try {
      final provider = ref.read(communityCreationProvider);
      final result = await AsyncValue.guard(
          () => provider.editCommunityDesc(currentCommunity, communityDesc));
      if (result.value['Success']) {
        state = AsyncData({
          'Function': "editCommunityDesc",
          "msg": result.value['response']
        });
       
      } else {
        final error = {
          'Function': 'editCommunityDesc',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> createVirtue(
    String currentCommunity, String virtueName, String definition, String virtueColor) async {
    try {
      final provider = ref.read(communityCreationProvider);
      final result = await AsyncValue.guard(
          () => provider.createVirtue(currentCommunity, virtueName, definition, virtueColor));

      if (result.value['Success']) {
        state = AsyncData({
          'Function': "createVirtue",
          "msg": result.value['response']
        });
       
      } else {
        final error = {
          'Function': 'createVirtue',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> editVirtueInfo(
    String currentCommunity, String currentVirtue, String? definition, String? virtueColor) async {
    try {
      final provider = ref.read(communityCreationProvider);
      final result = await AsyncValue.guard(
          () => provider.editVirtueInfo(currentCommunity, currentVirtue, definition, virtueColor));
      if (result.value['Success']) {
        state = AsyncData({
          'Function': "editVirtueInfo",
          "msg": result.value['response']
        });
       
      } else {
        final error = {
          'Function': 'editVirtueInfo',
          'msg': result.value['Error']
        };

        state = AsyncError(error, StackTrace.current);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

}
