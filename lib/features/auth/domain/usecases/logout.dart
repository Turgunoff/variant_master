import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:variant_master/core/error/failures.dart';
import 'package:variant_master/core/usecases/usecase.dart';
import 'package:variant_master/features/auth/domain/repositories/auth_repository.dart';

@injectable
class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
