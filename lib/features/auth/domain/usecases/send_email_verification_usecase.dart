import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendEmailVerificationUsecase {
  final AuthRepository _repository;

  const SendEmailVerificationUsecase(this._repository);

  Future<Either<AuthFailures, Unit>> call() {
    return _repository.sendEmailVerification();
  }
}
