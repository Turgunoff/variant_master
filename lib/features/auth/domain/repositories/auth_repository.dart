import 'package:dartz/dartz.dart';

import 'package:variant_master/core/error/failures.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Check if user is authenticated
  Future<Either<Failure, User?>> checkAuth();

  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Logout user
  Future<Either<Failure, void>> logout();
}
