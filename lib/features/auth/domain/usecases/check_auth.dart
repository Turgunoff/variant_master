import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:variant_master/core/error/failures.dart';
import 'package:variant_master/core/usecases/usecase.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/auth/domain/repositories/auth_repository.dart';

@injectable
class CheckAuth implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  CheckAuth(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return repository.checkAuth();
  }
}
