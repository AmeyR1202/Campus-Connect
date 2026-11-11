// Talks to Cloud Firestore (users collection)

import 'package:campus_connect/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class FirestoreUserDatasource {
  Future<void> createUserProfile({required UserModel user});
  Future<UserModel?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserModel user);
  Future<void> deleteUserProfile(String userId);
}

class FirestoreUserDatasourceImpl implements FirestoreUserDatasource {
  final FirebaseFirestore _firestore;

  FirestoreUserDatasourceImpl(this._firestore);

  /// LEARNED:services, repositories, and data sources that hold runtime SDK instances,
  /// leaving the constructor as a standard constructor
  /// (FirebaseAuthDataSourceImpl(this._firebaseAuth);) is standard practice.
  /// FirebaseAuth.instance is a runtime object (it connects to native iOS/Android C++ engines, platform channels, and memory).
  /// It does not have a const constructor.

  @override
  Future<void> createUserProfile({required UserModel user}) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .set(user.toFirestore());
  }

  @override
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return UserModel.fromFirestore(doc.data()!, doc.id);

    /// LEARNED: We use data(): Contains all the data of this document snapshot.
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.userId)
        .update(user.toFirestore());
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
