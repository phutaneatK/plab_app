import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plab_app/core/router/app_routes.dart';
import 'package:plab_app/presentation/login/pages/login_page.dart';
import 'package:plab_app/presentation/home/pages/home_page.dart';
import 'package:plab_app/presentation/nasa/pages/nasa_settings_page.dart';
import 'package:plab_app/core/services/auth_service.dart';
import 'package:plab_app/presentation/nasa/bloc/nasa_history_bloc.dart';
import 'package:plab_app/presentation/nasa/cubit/nasa_search_query_cubit.dart';
import 'package:plab_app/presentation/chat/bloc/chat_bloc.dart';
import 'package:plab_app/presentation/pm25/blocs/pm25_bloc.dart';
import 'package:plab_app/injection.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  // Private constructor
  AppRouter._();

  static final AuthService _authService = AuthService();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.login,
    redirect: (context, state) async {
      final isValidToken = await _authService.isValidToken();
      final isGoingToLogin = state.matchedLocation == AppRoutes.login;
      
      // ถ้ายังไม่ได้ login และไม่ได้กำลังไปหน้า login -> redirect ไป login
      if (!isValidToken && !isGoingToLogin) return AppRoutes.login;
      
      // ถ้า login แล้วแต่กำลังไปหน้า login -> redirect ไป home
      if (isValidToken && isGoingToLogin) return AppRoutes.home;
      
      return null;
    },
    routes: [
      // ==================== Login Route ====================
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
      ),

      // ==================== Home Route ====================
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<NasaHistoryBloc>()),
            BlocProvider(create: (context) => getIt<ChatBloc>()),
            BlocProvider(create: (context) => getIt<Pm25Bloc>()),
            BlocProvider(create: (context) => getIt<NasaSearchQueryCubit>()),
          ],
          child: const HomePage(),
        ),
      ),

      // ==================== NASA Settings Route ====================
      GoRoute(
        path: AppRoutes.nasaSettings,
        name: AppRoutes.nasaSettingsName,
        builder: (context, state) => BlocProvider.value(
          value: getIt<NasaSearchQueryCubit>(),
          child: const NasaSettingsPage(),
        ),
      ),
    ],
  );
}
