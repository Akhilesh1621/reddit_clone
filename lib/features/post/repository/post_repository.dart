// firebase logic

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constant.dart';
import 'package:reddit_clone/core/faliure.dart';
import 'package:reddit_clone/core/type_defs.dart';

import '../../../core/provider/firebase_provider.dart';
import '../../../models/comment_model.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(
        _posts.doc(post.id).delete(),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //upvotes & downvote

  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove(
            [userId],
          )
        },
      );
    }
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove(
            [userId],
          )
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayUnion(
            [userId],
          )
        },
      );
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove(
            [userId],
          )
        },
      );
    }
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove(
            [userId],
          )
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayUnion(
            [userId],
          )
        },
      );
    }
  }
  //getting post bby id

  Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map(
          (event) => Post.fromMap(event.data() as Map<String, dynamic>),
        );
  }

// comment adding
  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(
        _posts.doc(comment.postid).update({
          'commentCount': FieldValue.increment(1),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // list view of comment card..

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comments
        .where('postid', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return Comment.fromMap(
          e.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  //gifting awards

  FutureVoid awardPost(Post post, String awards, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([awards]),
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([awards]),
      });
      return right(_users.doc(post.uid).update({
        'awards': FieldValue.arrayUnion([awards]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
