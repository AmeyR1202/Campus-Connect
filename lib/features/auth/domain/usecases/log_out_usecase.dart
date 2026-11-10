import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogOutUsecase {
  final AuthRepository _repository;
  const LogOutUsecase(this._repository);

  Future<Either<AuthFailures, Unit>> call() {
    return _repository.logout();
  }
}
