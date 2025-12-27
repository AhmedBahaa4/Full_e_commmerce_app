import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/pages/add_new_card_page.dart';
import 'package:e_commerc_app/views/pages/change_password_page.dart';
import 'package:e_commerc_app/views/pages/checkout_page.dart';
import 'package:e_commerc_app/views/pages/choose_location_page.dart';
import 'package:e_commerc_app/views/pages/custom_bottom_nav_bar.dart';
import 'package:e_commerc_app/views/pages/edit_profile_page.dart';
import 'package:e_commerc_app/views/pages/login_page.dart';
import 'package:e_commerc_app/views/pages/onboarding_page.dart';
import 'package:e_commerc_app/views/pages/product_details_page.dart';
import 'package:e_commerc_app/views/pages/register_page.dart';
import 'package:e_commerc_app/views_models/cubit/auth_cubit/auth_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/check_out_cubit/check_out_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/choose-location_cubit/choose_location_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/password_cubit/password_cubit_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/payment_method_cubit/payment_method_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/prodcut_details_page/product_deails_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeroute:
        return MaterialPageRoute(
          builder: (_) => const CustomBottomNavBar(),

          settings: settings,
        );
      case AppRoutes.checkoutRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => CheckOutCubit()..getCheckoutContent(),
              ),
              BlocProvider(create: (_) => PaymentMethodsCubit()),
            ],
            child: const CheckoutPage(),
          ),

          settings: settings,
        );
      case AppRoutes.editProfileRoute:
        return MaterialPageRoute(
          builder: (_) => const EditProfilePage(),

          settings: settings,
        );
          case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) =>  OnboardingPage(),

          settings: settings,
        );

      case AppRoutes.changePasswordRoute:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PasswordCubit()),
              BlocProvider(create: (_) => AuthCubit()),
            ],
            child: const ChangePasswordPage(),
          ),
          settings: settings,
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PasswordCubit()),
              BlocProvider(create: (_) => AuthCubit()),
            ],
            child: const RegisterPage(),
          ),
          settings: settings,
        );

      case AppRoutes.loginPage:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PasswordCubit()),
              BlocProvider(create: (_) => AuthCubit()),
            ],
            child: const LoginPage(),
          ),
          settings: settings,
        );

      case AppRoutes.addNewCardRoute:
        final paymentMethodsCubit = settings.arguments as PaymentMethodsCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: paymentMethodsCubit,

            child: const AddNewCardPage(),
          ), // remove block provider

          settings: settings,
        );

      case AppRoutes.chooseLocation:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ChooseLocationCubit();
              cubit.fetchLocations();
              return cubit;
            },

            child: const ChooseLocationPage(),
          ),

          settings: settings,
        );

      case AppRoutes.productDetailsRoute:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ProductDeailsCubit();
              cubit.getProductDetails(productId);
              return cubit;
            },
            child: ProductDetailsPage(productId: productId),
          ),

          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No Route Found ${settings.name}')),
          ),
        );
    }
  }
}
