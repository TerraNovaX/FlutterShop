import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/router.dart';

import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/catalog_viewmodel.dart';
import 'presentation/viewmodels/product_viewmodel.dart';
import 'presentation/viewmodels/cart_viewmodel.dart';
import 'presentation/viewmodels/checkout_viewmodel.dart';
import 'data/repositories/order_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
    ChangeNotifierProvider(create: (_) => CatalogViewModel()),
    ChangeNotifierProvider(create: (_) => ProductViewModel()),
    ChangeNotifierProvider(create: (_) => CartViewModel()),
    ChangeNotifierProvider(
      create: (_) => CheckoutViewModel(OrderRepository()),
    ),
  ],
      builder: (context, _) {
        final router = createRouter(context);

        return MaterialApp.router(
          title: 'Flutter Shop',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
