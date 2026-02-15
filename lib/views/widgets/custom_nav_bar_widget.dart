import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomNavBarWidget extends StatelessWidget {
  final NavBarConfig config;
  final PersistentTabController controller;

  const CustomNavBarWidget(this.config, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey,
          selectedFontSize: 15,
          unselectedFontSize: 14,
          currentIndex: controller.index,
          onTap: (index) => controller.jumpToTab(index),
          items: config.items.map((item) {
            return BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                // decoration: BoxDecoration(
                //   color: controller.index == config.items.indexOf(item)
                //       // ignore: deprecated_member_use
                //       ? AppColors.white
                //       : Colors.transparent,
                //   borderRadius: BorderRadius.circular(15),
                // ),
                child: item.icon,
              ),
              label: item.title,
            );
          }).toList(),
        ),
      ),
    );
  }
}
