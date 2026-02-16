import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
import 'package:e_commerc_app/views_models/cubit/fav_cubit/favorite_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.read<FavoriteCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<FavoriteCubit, FavoriteCubitState>(
          bloc: favoriteCubit,
          listenWhen: (previous, current) =>
              current is FavoriteRmovevEror || current is FavoriteRmoved,
          listener: (context, state) {
            if (state is FavoriteRmovevEror) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is FavoriteRmoved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Removed from favorites')),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is FavoriteLoading ||
              current is FavoriteLoaded ||
              current is FavoriteError ||
              current is FavoriteRmoveving ||
              current is FavoriteRmoved,
          builder: (context, state) {
            final products = state is FavoriteLoaded
                ? state.favoriteProducts
                : favoriteCubit.favoriteProducts;

            if (state is FavoriteLoading && products.isEmpty) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state is FavoriteError && products.isEmpty) {
              return _FavoritesErrorView(
                message: state.message,
                onRetry: () => favoriteCubit.getFavoriteProducts(),
              );
            }

            if (products.isEmpty) {
              return RefreshIndicator(
                onRefresh: () =>
                    favoriteCubit.getFavoriteProducts(showLoading: false),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
                    const _FavoritesEmptyView(),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  favoriteCubit.getFavoriteProducts(showLoading: false),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = ResponsiveHelper.maxContentWidth(context);
                  final horizontalPadding = ResponsiveHelper.horizontalPadding(
                    context,
                  );

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          16,
                          horizontalPadding,
                          24,
                        ),
                        children: [
                          _FavoriteHeader(totalItems: products.length),
                          const SizedBox(height: 16),
                          ...products.map(
                            (product) => _FavoriteCard(
                              product: product,
                              isRemoving:
                                  state is FavoriteRmoveving &&
                                  state.productId == product.id,
                              onRemove: () =>
                                  favoriteCubit.removeFavorite(product.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FavoriteHeader extends StatelessWidget {
  final int totalItems;

  const _FavoriteHeader({required this.totalItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF9F43FF), Color(0xFF6C4DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Favorite Products',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalItems items saved',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final ProductItemModel product;
  final bool isRemoving;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.product,
    required this.isRemoving,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(AppRoutes.productDetailsRoute, arguments: product.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.grey2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product.imgUrl,
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => const SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                    errorWidget: (context, _, __) =>
                        const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.averageRate.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: isRemoving ? null : onRemove,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isRemoving
                        ? const Padding(
                            padding: EdgeInsets.all(9),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.red,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoritesEmptyView extends StatelessWidget {
  const _FavoritesEmptyView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 82,
          width: 82,
          decoration: BoxDecoration(
            color: AppColors.grey2,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.favorite_border_rounded,
            size: 42,
            color: AppColors.black2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'No favorites yet',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap the heart on any product to save it here.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.black2),
        ),
      ],
    );
  }
}

class _FavoritesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FavoritesErrorView({required this.message, required this.onRetry});

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
              size: 44,
              color: AppColors.red,
            ),
            const SizedBox(height: 10),
            Text(
              'Could not load favorites',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
