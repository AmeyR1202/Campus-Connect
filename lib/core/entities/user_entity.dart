import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String username;
  final String email;
  final bool isEmailVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.userId,
    required this.username,
    required this.email,
    required this.isEmailVerified,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? userId,
    String? username,
    String? email,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    isEmailVerified,
    createdAt,
  ];
}
