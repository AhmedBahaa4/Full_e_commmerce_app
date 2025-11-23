import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_router.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views_models/cubit/auth_cubit/auth_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/fav_cubit/favorite_cubit_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/prodcut_details_page/product_deails_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  await initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (context) => CartCubit()..getCartItems(),
        ),
        BlocProvider<ProductDeailsCubit>(
          create: (context) => ProductDeailsCubit(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit()..getHomeData(),
        ),
        // BlocProvider<CheckOutCubit>(
        //   create: (context) => CheckOutCubit()..getCheckOutData(),
        // ),
        BlocProvider<FavoriteCubit>(
          create: (context) => FavoriteCubit()..getFavoriteProducts(),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await handleNotifications();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint('Handling a background message: ${message.messageId}');
}

Future<void> handleNotifications() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notification settings here
  //Taking prermission
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    ('Got a message whilst in the foreground!');
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    ('Message data: ${message.data}');

    if (message.notification != null) {
    String title = message.notification!.title ?? 'No Title';
    String body = message.notification!.body ?? 'No Body';
    debugPrint('Message also contained a notification: $title');
    debugPrint('Message also contained a notification: $body');

    showDialog(context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(body),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            )
    );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    debugPrint('A new onMessageOpenedApp event was published!');
    debugPrint('User granted permission: ${settings.authorizationStatus}');
    debugPrint('Message data: ${message.data}');
   final messageData = message.data;
    if (messageData['product_id'] != null) {
      final productId = messageData['product_id'];
      navigatorKey.currentState?.pushNamed(
        AppRoutes.productDetailsRoute,
        arguments: {'product_id': productId},
      );
    }
  });

  // Handle background messages
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AuthCubit();
        cubit.checkAuth();
        return cubit;
      },
      child: Builder(
        builder: (context) {
          final authCubit = BlocProvider.of<AuthCubit>(context);
          return BlocBuilder<AuthCubit, AuthState>(
            bloc: authCubit,
            buildWhen: (previous, current) =>
                current is AuthDone || current is AuthInitial,
            builder: (context, state) {
              if (state is AuthDone) {}
              return MaterialApp(
                navigatorKey:  navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'E-Commerce App',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  brightness: Brightness.light,
                  scaffoldBackgroundColor: AppColors.white,
                ),
                initialRoute: state is AuthDone
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
