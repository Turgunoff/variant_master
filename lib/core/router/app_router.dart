import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';

import 'package:variant_master/features/admin/presentation/screens/directions_screen.dart';
import 'package:variant_master/features/admin/presentation/screens/moderators_screen.dart';
import 'package:variant_master/features/admin/presentation/screens/subjects_screen.dart';
import 'package:variant_master/features/admin/presentation/screens/teachers_screen.dart';
import 'package:variant_master/features/auth/bloc/auth_bloc.dart';
import 'package:variant_master/features/auth/presentation/screens/login_screen.dart';
import 'package:variant_master/features/auth/presentation/screens/settings_screen.dart';
import 'package:variant_master/features/moderator/presentation/screens/test_review_screen.dart';
import 'package:variant_master/features/admin/presentation/screens/create_variant_screen.dart';
import 'package:variant_master/features/teacher/presentation/screens/dashboard_screen.dart';
import 'package:variant_master/features/teacher/presentation/screens/tests_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';
      final currentPath = state.matchedLocation;

      // If not authenticated and not on login page, redirect to login
      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      // If authenticated and on login page, redirect to dashboard
      if (isAuthenticated && isLoginRoute) {
        return '/dashboard';
      }

      // Role-based access control for routes
      if (isAuthenticated) {
        final user = authState.user;

        // Teacher can only access dashboard
        if (user.role == UserRole.teacher) {
          final allowedRoutes = ['/dashboard'];
          if (!allowedRoutes.contains(currentPath)) {
            return '/dashboard';
          }
        }
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Login route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Dashboard route
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Moderators route
      GoRoute(
        path: '/moderators',
        name: 'moderators',
        builder: (context, state) => const ModeratorsScreen(),
      ),

      // Tests route
      GoRoute(
        path: '/tests',
        name: 'tests',
        builder: (context, state) => const TestsScreen(),
      ),

      // Test review route
      GoRoute(
        path: '/test-review',
        name: 'test-review',
        builder: (context, state) => const TestReviewScreen(),
      ),

      // Teachers route
      GoRoute(
        path: '/teachers',
        name: 'teachers',
        builder: (context, state) => const TeachersScreen(),
      ),

      // Directions route
      GoRoute(
        path: '/directions',
        name: 'directions',
        builder: (context, state) => const DirectionsScreen(),
      ),

      // Subjects route
      GoRoute(
        path: '/subjects',
        name: 'subjects',
        builder: (context, state) => const SubjectsScreen(),
      ),

      // Create variant route
      GoRoute(
        path: '/create-variant',
        name: 'create-variant',
        builder: (context, state) => const CreateVariantScreen(),
      ),

      // Settings route
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

// Helper class to convert BLoC stream to Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  late final Stream<dynamic> _stream;
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) : _stream = stream {
    _subscription = _stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
