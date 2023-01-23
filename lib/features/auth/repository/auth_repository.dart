import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constant.dart';
import 'package:reddit_clone/core/faliure.dart';
import 'package:reddit_clone/core/provider/firebase_provider.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/user_model.dart';

//accesed from firebase provider.dart bca we keep all our firebase realted provider in that
final authRepositoryProvider = Provider((ref) => AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignIn),
    ));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

//database collection getter

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);

//firebase state persistance
//to check the changes or updates after login
  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      //google SignIn which provides us method and to view the enails
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
//user auth for storing all our user in console
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        //storing the data in firestore
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'NO Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: userCredential.user!.photoURL ?? Constants.bannerDefault,
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          isAuthenticated: true,
          karma: 0,
          awards: [
            'awesomeAns',
            'til',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
          ],
        );

        await _user.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        //if user allready exeist then we use this
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      //error handling
      return right(userModel);
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

// for first data from stream and page shoudnt rebuid again so we use stream here
  Stream<UserModel> getUserData(String uid) {
    return _user.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
