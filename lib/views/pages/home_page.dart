import 'package:e_commerc_app/utils/app_color.dart';

import 'package:e_commerc_app/views/widgets/category_tab_view.dart';
import 'package:e_commerc_app/views/widgets/home_tab_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabcontroller;
  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SafeArea(
            child: Column(
              children: [
                TabBar(
                  controller: _tabcontroller,
                  unselectedLabelColor: AppColors.grey,
                  unselectedLabelStyle: const TextStyle(fontSize: 16),

                  tabs: const [
                    Tab(text: 'Home'),

                    Tab(text: 'Category'),
                  ],
                ),
                const SizedBox(height: 26),
                Expanded(
                  child: TabBarView(
                    controller: _tabcontroller,
                    children: const [HomeTabView(), CategoryTabView()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
