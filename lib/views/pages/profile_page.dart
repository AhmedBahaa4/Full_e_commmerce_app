import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/widgets/profile_item_widget.dart';
import 'package:e_commerc_app/views_models/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ===== قسم General =====
          Text(
            'General',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),

          ProfileItemWidget(
            title: 'Edit Profile',
            icon: Icons.menu,
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AppRoutes.editProfileRoute);
            },
          ),
          const SizedBox(height: 8.0),

          ProfileItemWidget(
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AppRoutes.changePasswordRoute);
            },
          ),
          const SizedBox(height: 8.0),

          const ProfileItemWidget(
            title: 'Notifications',
            icon: Icons.notifications_none,
          ),
          const SizedBox(height: 8.0),

          const ProfileItemWidget(
            title: 'Security',
            icon: Icons.security_outlined,
          ),
          const SizedBox(height: 8.0),

          const ProfileItemWidget(
            title: 'Language',
            icon: Icons.language,
            trailingText: 'English',
          ),

          const SizedBox(height: 24.0),

          // ===== قسم Preferences =====
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16.0),

          const ProfileItemWidget(
            title: 'Legal and Policies',
            icon: Icons.policy_outlined,
          ),
          const SizedBox(height: 8.0),

          const ProfileItemWidget(
            title: 'Help & Support',
            icon: Icons.help_outline,
          ),
          const SizedBox(height: 8.0),

          BlocConsumer<AuthCubit, AuthState>(
            bloc: cubit,
            listenWhen: (previous, current) =>
                current is AuthLoggedOut || current is AuthLoggedOutError,
            listener: (context, state) {
              if (state is AuthLoggedOut) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamedAndRemoveUntil(
                  AppRoutes.loginPage,
                  (route) => false,
                );
              } else if (state is AuthLoggedOutError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            buildWhen: (previous, current) => current is AuthloggingOut,
            builder: (context, state) {
              if (state is AuthloggingOut) {
                return const Center(child: CircularProgressIndicator());
              }
              return ProfileItemWidget(
                title: 'Logout',
                icon: Icons.logout,
                iconColor: AppColors.red,
                textColor: AppColors.red,
                onTap: () async => await cubit.logout(),
              );
            },
          ),
        ],
      ),
    );
  }
}
