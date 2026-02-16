import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/pages/favorite_page.dart';
import 'package:e_commerc_app/views/pages/cart_page.dart';
import 'package:e_commerc_app/views/pages/profile_page.dart';
import 'package:e_commerc_app/views/widgets/custom_nav_bar_widget.dart';
import 'package:e_commerc_app/views/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_commerc_app/views/pages/home_page.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/fav_cubit/favorite_cubit_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getHomeData();
      context.read<CartCubit>().getCartItems();
      context.read<FavoriteCubit>().getFavoriteProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(controller: _controller),

      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.black,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 8),

                // Text(
                //   currentIndex == 0
                //       ? 'Home'
                //       : currentIndex == 1
                //           ? 'Cart'
                //           : currentIndex == 2
                //               ? 'Favorites'
                //               : 'Profile',
                //   style: const TextStyle(
                //     color: AppColors.black,
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),

            // أيقونات البحث والإشعارات
            Row(
              children: [
                if (currentIndex == 0) ...[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.black,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Stack(
                      children: [
                        const Icon(
                          Icons.notifications_rounded,
                          color: AppColors.black,
                          size: 28,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '2', // عدد الإشعارات
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (currentIndex == 1) ...[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shopping_bag,
                      color: AppColors.black,
                      size: 28,
                    ),
                  ),
                ] else if (currentIndex == 2) ...[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                      color: AppColors.black,
                      size: 28,
                    ),
                  ),
                ] else if (currentIndex == 3) ...[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person,
                      color: AppColors.black,
                      size: 28,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),

      body: PersistentTabView(
        controller: _controller,
        tabs: [
          PersistentTabConfig(
            screen: const HomePage(),
            item: ItemConfig(
              icon: const Icon(Icons.home_outlined, size: 30),
              title: 'Home',
            ),
          ),
          PersistentTabConfig(
            screen: const CartPage(),
            item: ItemConfig(
              icon: const Icon(Icons.shopping_cart_outlined, size: 30),
              title: 'Cart',
            ),
          ),
          PersistentTabConfig(
            screen: const Favorites(),
            item: ItemConfig(
              icon: const Icon(Icons.favorite_border_outlined, size: 30),
              title: 'Favorites',
            ),
          ),

          PersistentTabConfig(
            screen: const Profile(),
            item: ItemConfig(
              icon: const Icon(Icons.person, size: 30),
              title: 'Profile',
            ),
          ),
        ],

        backgroundColor: AppColors.white,
        gestureNavigationEnabled: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        onTabChanged: (index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 1) {
            context.read<CartCubit>().getCartItems(showLoading: false);
          } else if (index == 2) {
            context.read<FavoriteCubit>().getFavoriteProducts(
              showLoading: false,
            );
          }
        },
        navBarBuilder: (NavBarConfig p1) {
          return CustomNavBarWidget(p1, _controller);
        },
      ),
    );
  }
}
