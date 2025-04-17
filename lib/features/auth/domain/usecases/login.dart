import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:variant_master/core/error/failures.dart';
import 'package:variant_master/core/usecases/usecase.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/auth/domain/repositories/auth_repository.dart';

@injectable
class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
