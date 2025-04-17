import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:variant_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:variant_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:variant_master/features/auth/domain/usecases/check_auth.dart';
import 'package:variant_master/features/auth/domain/usecases/login.dart';
import 'package:variant_master/features/auth/domain/usecases/logout.dart';
import 'package:variant_master/core/network/network_info.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await _registerDependencies();
  _registerAuthDependencies();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

Future<void> _registerDependencies() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Register Connectivity
  getIt.registerLazySingleton(() => Connectivity());

  // Register NetworkInfo
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );
}

void _registerAuthDependencies() {
  // Register Auth dependencies
  getIt.registerLazySingleton<AuthLocalDatasource>(
    () =>
        AuthLocalDatasourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDatasource: getIt<AuthLocalDatasource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Register Auth usecases
  getIt.registerLazySingleton(
    () => CheckAuth(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => Login(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => Logout(getIt<AuthRepository>()),
  );

  // Register Auth bloc
  getIt.registerFactory(
    () => AuthBloc(
      checkAuth: getIt<CheckAuth>(),
      login: getIt<Login>(),
      logout: getIt<Logout>(),
    ),
  );
}
