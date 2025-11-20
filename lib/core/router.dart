import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/pages/login_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/catalog_page.dart';
import '../presentation/pages/cart_page.dart';
import '../presentation/pages/checkout_page.dart';
import '../presentation/pages/product_detail_page.dart';

import 'guards.dart';

GoRouter createRouter(BuildContext context) {
  final auth = Provider.of<AuthViewModel>(context, listen: false);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: auth, 
    redirect: (ctx, state) => AuthGuard.redirect(ctx, state),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (ctx, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (ctx, state) => const HomePage(),
      ),
      GoRoute(
        path: '/catalog',
        name: 'catalog',
        builder: (ctx, state) => const CatalogPage(),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (ctx, state) => const CartPage(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (ctx, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (ctx, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailPage(productId: id);
        },
      ),
    ],
  );
}
