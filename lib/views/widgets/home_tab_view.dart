import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/home_carousel_item_model.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
import 'package:e_commerc_app/views/widgets/ai_floating_button.dart';
import 'package:e_commerc_app/views/widgets/product_item.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeLoading ||
          current is HomeLoaded ||
          current is HomeError,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const _HomeLoadingView();
        }

        if (state is HomeError) {
          return _HomeErrorView(
            message: state.message,
            onRetry: homeCubit.getHomeData,
          );
        }

        if (state is! HomeLoaded) {
          return const SizedBox.shrink();
        }

        return _HomeLoadedView(state: state);
      },
    );
  }
}

class _HomeLoadedView extends StatelessWidget {
  final HomeLoaded state;

  const _HomeLoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final allProducts = homeCubit.allProducts;
    final visibleProducts = state.products;
    final hasSearch = state.searchQuery.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = ResponsiveHelper.maxContentWidth(context);
        final horizontalPadding = ResponsiveHelper.horizontalPadding(context);
        final availableWidth = constraints.maxWidth > maxContentWidth
            ? maxContentWidth
            : constraints.maxWidth;
        final gridCount = ResponsiveHelper.productGridCount(availableWidth);
        final childAspectRatio = availableWidth >= 1000 ? 0.76 : 0.66;

        return Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: RefreshIndicator(
                  onRefresh: homeCubit.getHomeData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      6,
                      horizontalPadding,
                      30,
                    ),
                    children: [
                      _QuickStats(
                        allProducts: allProducts,
                        visibleProducts: visibleProducts,
                      ),
                      const SizedBox(height: 16),
                      _PromoCarousel(items: state.carouselItems),
                      const SizedBox(height: 16),
                      _SectionHeader(
                        title: 'New Arrivals',
                        subtitle: hasSearch
                            ? 'Results for "${state.searchQuery}" • ${visibleProducts.length} item(s)'
                            : '${visibleProducts.length} products',
                      ),
                      const SizedBox(height: 10),
                      if (visibleProducts.isEmpty && hasSearch)
                        _NoSearchResults(query: state.searchQuery)
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: visibleProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridCount,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: childAspectRatio,
                              ),
                          itemBuilder: (context, index) {
                            final product = visibleProducts[index];
                            return InkWell(
                              onTap: () =>
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pushNamed(
                                    AppRoutes.productDetailsRoute,
                                    arguments: product.id,
                                  ),
                              borderRadius: BorderRadius.circular(18),
                              child: ProductItem(productItem: product),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const AiFloatingButton(),
          ],
        );
      },
    );
  }
}

class _QuickStats extends StatelessWidget {
  final List<ProductItemModel> allProducts;
  final List<ProductItemModel> visibleProducts;

  const _QuickStats({required this.allProducts, required this.visibleProducts});

  @override
  Widget build(BuildContext context) {
    final totalProducts = allProducts.length;
    final favoriteCount = allProducts
        .where((product) => product.isFavorite)
        .length;

    return Row(
      children: [
        Expanded(
          child: _StatTile(
            title: 'Visible',
            value: '${visibleProducts.length}',
            icon: Icons.grid_view_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            title: 'Products',
            value: '$totalProducts',
            icon: Icons.inventory_2_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            title: 'Favorites',
            value: '$favoriteCount',
            icon: Icons.favorite_border_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
          ),
        ],
      ),
    );
  }
}

class _PromoCarousel extends StatelessWidget {
  final List<HomeCarouselItemModel> items;

  const _PromoCarousel({required this.items});

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.sizeOf(context).width;
    final height = (availableWidth * 0.44).clamp(160.0, 250.0);

    if (items.isEmpty) {
      return Container(
        height: height.toDouble(),
        decoration: BoxDecoration(
          color: AppColors.grey2,
          borderRadius: BorderRadius.circular(18),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: FlutterCarousel.builder(
        itemCount: items.length,
        itemBuilder: (context, index, realIndex) {
          return CachedNetworkImage(
            imageUrl: items[index].imgUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline_rounded, color: AppColors.red),
          );
        },
        options: FlutterCarouselOptions(
          height: height.toDouble(),
          autoPlay: true,
          viewportFraction: 1,
          enableInfiniteScroll: true,
          showIndicator: true,
          autoPlayCurve: Curves.easeInOut,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 700),
          slideIndicator: CircularWaveSlideIndicator(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 10),
          Text(
            'Loading products...',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.black2),
          ),
        ],
      ),
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.red,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.black2),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  final String query;

  const _NoSearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.grey2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 36,
            color: AppColors.black2,
          ),
          const SizedBox(height: 8),
          Text(
            'No results for "$query"',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try another product name.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
          ),
        ],
      ),
    );
  }
}
