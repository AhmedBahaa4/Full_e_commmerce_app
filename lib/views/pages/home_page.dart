import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
import 'package:e_commerc_app/views/widgets/category_tab_view.dart';
import 'package:e_commerc_app/views/widgets/home_tab_view.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<HomeCubit>().setSearchQuery(_searchController.text);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveHelper.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              child: _HomeHeader(
                controller: _searchController,
                onClear: () => _searchController.clear(),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _TabsSegment(controller: _tabController),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [HomeTabView(), CategoryTabView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const _HomeHeader({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF4E36D7), Color(0xFF7E57FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover What You Need',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Type product name from first letter to filter instantly.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: AppColors.white),
            cursorColor: AppColors.white,
            decoration: InputDecoration(
              hintText: 'Search products, categories...',
              hintStyle: TextStyle(
                color: AppColors.white.withValues(alpha: 0.75),
              ),
              filled: true,
              fillColor: AppColors.white.withValues(alpha: 0.15),
              prefixIcon: const Icon(Icons.search, color: AppColors.white),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: onClear,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabsSegment extends StatelessWidget {
  final TabController controller;

  const _TabsSegment({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.black2,
        labelStyle: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        tabs: const [
          Tab(text: 'Home'),
          Tab(text: 'Category'),
        ],
      ),
    );
  }
}
