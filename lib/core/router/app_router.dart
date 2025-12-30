import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plab_app/presentation/login/pages/login_page.dart';
import 'package:plab_app/presentation/home/pages/home_page.dart';
import 'package:plab_app/presentation/nasa_history/pages/nasa_settings_page.dart';
import 'package:plab_app/core/services/auth_service.dart';
import 'package:plab_app/presentation/nasa_history/bloc/nasa_history_bloc.dart';
import 'package:plab_app/presentation/nasa_history/cubit/nasa_search_query_cubit.dart';
import 'package:plab_app/presentation/chat/bloc/chat_bloc.dart';
import 'package:plab_app/injection.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class PRouter {
  static final AuthService _authService = AuthService();

  static const homeRouter = "/${HomePage.routerName}";
  static const loginRouter = "/${LoginPage.routerName}";

  static const nasaSettingRouter = "/${NasaSettingsPage.routerName}";

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: loginRouter,
    redirect: (context, state) async {
      final isValidToken = await _authService.isValidToken();
      final isGoingToLogin = state.matchedLocation == loginRouter;
      if (!isValidToken && !isGoingToLogin) return loginRouter;
      if (isValidToken && isGoingToLogin) return homeRouter;
      return null;
    },
    routes: [
      pPage(path: LoginPage.routerName, page: const LoginPage()),
      pPage(
        path: HomePage.routerName,
        page: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<NasaHistoryBloc>()),
            BlocProvider(create: (context) => getIt<ChatBloc>()),
            BlocProvider(create: (context) => getIt<NasaSearchQueryCubit>()),
          ],
          child: const HomePage(),
        ),
      ),
      pPage(
        path: NasaSettingsPage.routerName,
        page: BlocProvider.value(
          value: getIt<NasaSearchQueryCubit>(),
          child: const NasaSettingsPage(),
        ),
      ),
    ],
  );
}

GoRoute pPage({required String path, required Widget page}) {
  return GoRoute(path: '/$path', name: path, builder: (context, state) => page);
}
