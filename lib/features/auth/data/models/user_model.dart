import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campus_connect/core/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.username,
    required super.email,
    required super.isEmailVerified,
    super.createdAt,
  });

  /// Factory to map from Firebase Auth's User object
  factory UserModel.fromFirebaseUser(User user, {String? username}) {
    return UserModel(
      userId: user.uid,
      username: username ?? user.displayName ?? '',
      email: user.email ?? '',
      isEmailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }

  /// Factory to map from Cloud Firestore document snapshot
  factory UserModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return UserModel(
      userId: docId,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Serializer to save to Cloud Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
