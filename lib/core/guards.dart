import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';

class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final auth = context.read<AuthViewModel>();
    final isLoggedIn = auth.user != null;
    final isOnLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isOnLogin) {
      
      return '/login';
    }

    if (isLoggedIn && isOnLogin) {
      
      return '/home';
    }

    return null; 
  }
}
