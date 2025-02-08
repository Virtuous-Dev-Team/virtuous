import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserFeedback {
  final CollectionReference db = 
    FirebaseFirestore.instance.collection("Feedback");

  Future sendFeedback(String feedbackType, String message) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'Success': false, 'Error': "User not found"};
      }

      final payload = {
        'feedbackType': feedbackType,
        'message': message
      };

      await db.add(payload);

      return {'Success': true, "response": "User Feedback sent to database"};

    } on FirebaseException catch (error) {
      return {'Success': false, 'Error': error.message};
    }
  }
}

// Provider
final userFeedbackProvider = Provider<UserFeedback>((ref) {
  return UserFeedback();
});