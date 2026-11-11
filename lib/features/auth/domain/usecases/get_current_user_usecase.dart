import 'package:campus_connect/core/entities/user_entity.dart';
import 'package:campus_connect/features/auth/domain/failures/auth_failures.dart';
import 'package:campus_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentUserUsecase {
  final AuthRepository _repository;

  const GetCurrentUserUsecase(this._repository);

  Future<Either<AuthFailures, UserEntity?>> call() {
    return _repository.getCurrentUser();
  }
}
