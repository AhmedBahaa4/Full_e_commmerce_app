// ignore_for_file: use_build_context_synchronously

import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_router.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views_models/cubit/auth_cubit/auth_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/fav_cubit/favorite_cubit_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/onboarding/onboarding_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/prodcut_details_page/product_deails_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/theme_cubit/theme_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();

  /// ⭐ نعرف المستخدم شاف onboarding ولا لأ
  final bool seenOnboarding = await OnboardingCubit.hasSeenOnboarding();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => FavoriteCubit()),
        BlocProvider(create: (_) => ProductDeailsCubit()),
        BlocProvider(create: (_) => OnboardingCubit()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

Future<void> initializeApp() async {
  await Firebase.initializeApp();
  await handleNotifications();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> handleNotifications() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, sound: true);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (message.notification != null && context != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification!.title ?? ''),
          content: Text(message.notification!.body ?? ''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final productId = message.data['product_id']?.toString();
    if (productId != null && productId.isNotEmpty) {
      navigatorKey.currentState?.pushNamed(
        AppRoutes.productDetailsRoute,
        arguments: productId,
      );
    }
  });
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit()..checkAuth(),
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) =>
            current is AuthDone || current is AuthInitial,
        builder: (context, authState) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'E-Commerce App',
                themeMode: themeMode,
                theme: ThemeData(
                  brightness: Brightness.light,
                  scaffoldBackgroundColor: AppColors.white,
                  primarySwatch: Colors.blue,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: AppColors.black,
                  primarySwatch: Colors.blue,
                ),

                /// ⭐ هنا الدمج الصح
                initialRoute: !seenOnboarding
                    ? AppRoutes.onboarding
                    : authState is AuthDone
                    ? AppRoutes.homeroute
                    : AppRoutes.loginPage,

                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
