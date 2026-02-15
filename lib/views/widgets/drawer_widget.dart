import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views_models/cubit/theme_cubit/theme_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class DrawerWidget extends StatelessWidget {
  final PersistentTabController controller;

  const DrawerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : const NetworkImage(
                              'https://example.com/default_avatar.jpg',
                            )
                            as ImageProvider,
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'Guest User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          _drawerItem(
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              controller.jumpToTab(0);
              Navigator.pop(context);
            },
          ),
          _drawerItem(
            icon: Icons.shopping_cart_outlined,
            title: 'Cart',
            onTap: () {
              controller.jumpToTab(1);
              Navigator.pop(context);
            },
          ),
          _drawerItem(
            icon: Icons.favorite_border_outlined,
            title: 'Favorites',
            onTap: () {
              controller.jumpToTab(2);
              Navigator.pop(context);
            },
          ),
          _drawerItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () {
              controller.jumpToTab(3);
              Navigator.pop(context);
            },
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;

              return SwitchListTile(
                secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                title: const Text('Dark Mode'),
                value: isDark,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme(value);
                },
              );
            },
          ),

          const Spacer(),
          const Divider(),

          _drawerItem(
            icon: Icons.logout,
            title: 'Logout',
            color: AppColors.red,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                AppRoutes.loginPage,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Drawer Item
Widget _drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Color color = AppColors.black,
}) {
  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(
      title,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    onTap: onTap,
  );
}
