import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckEmailVerifiedUsecase {
  final AuthRepository _repository;

  const CheckEmailVerifiedUsecase(this._repository);

  Future<Either<AuthFailures, bool>> call() {
    return _repository.checkEmailVerified();
  }
}
