import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views_models/cubit/fav_cubit/favorite_cubit_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;

  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.grey5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: productItem.imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.grey2,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.black2,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: _CategoryPill(category: productItem.category),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _FavoriteButton(productItem: productItem),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.orange,
                        size: 17,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        productItem.averageRate.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.black2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${productItem.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String category;

  const _CategoryPill({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 24, maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        category,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColors.white),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final ProductItemModel productItem;

  const _FavoriteButton({required this.productItem});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          (current is SetFavoriteLoading &&
              current.productId == productItem.id) ||
          (current is SetFavoriteSuccess &&
              current.productId == productItem.id) ||
          (current is SetFavoriteError && current.productId == productItem.id),
      builder: (context, state) {
        final isLoading = state is SetFavoriteLoading;
        final isFavorite = state is SetFavoriteSuccess
            ? state.isFavorite
            : productItem.isFavorite;

        return Material(
          color: AppColors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(11),
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: isLoading
                ? null
                : () async {
                    await homeCubit.setFevorite(productItem);
                    if (!context.mounted) return;
                    await context.read<FavoriteCubit>().getFavoriteProducts(
                      showLoading: false,
                    );
                  },
            child: SizedBox(
              height: 30,
              width: 30,
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(7),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: isFavorite ? AppColors.red : AppColors.black2,
                    ),
            ),
          ),
        );
      },
    );
  }
}
