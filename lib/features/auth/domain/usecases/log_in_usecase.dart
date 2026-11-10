import 'package:campus_connect/core/entities/user_entity.dart';
import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogInUsecase {
  final AuthRepository _repository;

  const LogInUsecase(this._repository);

  Future<Either<AuthFailures, UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
