import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendPasswordResetEmailUsecase {
  final AuthRepository _repository;

  const SendPasswordResetEmailUsecase(this._repository);

  Future<Either<AuthFailures, Unit>> call({required String email}) {
    return _repository.sendPasswordResetEmail(email: email);
  }
}
