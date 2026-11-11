import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccountUsecase {
  final AuthRepository _repository;

  const DeleteAccountUsecase(this._repository);

  Future<Either<AuthFailures, Unit>> call() {
    return _repository.deleteAccount();
  }
}
