import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:variant_master/core/error/exceptions.dart';
import 'package:variant_master/core/error/failures.dart';
import 'package:variant_master/core/network/network_info.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:variant_master/features/auth/data/datasources/auth_local_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User?>> checkAuth() async {
    try {
      final user = await localDatasource.getLastLoggedInUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await localDatasource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDatasource.removeUser();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
