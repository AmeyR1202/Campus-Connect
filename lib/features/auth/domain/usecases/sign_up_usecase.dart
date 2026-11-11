import 'package:campus_connect/core/entities/user_entity.dart';
import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignUpUsecase {
  final AuthRepository _repository;

  const SignUpUsecase(this._repository);

  Future<Either<AuthFailures, UserEntity>> call({
    required String username,
    required String email,
    required String password,
  }) {
    return _repository.signUpWithEmailAndPassword(
      username: username,
      email: email,
      password: password,
    );
  }
}
