import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constant.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';

import '../../../core/faliure.dart';

import '../../../core/provider/firebase_provider.dart';
import '../../../core/type_defs.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRespository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRespository {
  final FirebaseFirestore _firestore;
  UserProfileRespository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(
        _users.doc(user.uid).update(
              user.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

//displayin post in user screen
  Stream<List<Post>> getUserPost(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ))
            .toList());
  }
}
