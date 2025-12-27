import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;

  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final size = MediaQuery.of(context).size;
    return  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    /// الصورة
    Expanded(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.greyshade,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CachedNetworkImage(
              imageUrl: productItem.imgUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red, size: 40),
            ),
          ),

          /// Favorite Icon
          Positioned(
            top: 3,
            right: 3,
            child: BlocBuilder<HomeCubit, HomeState>(
              bloc: homeCubit,
              buildWhen: (previous, current) =>
                  (current is SetFavoriteLoading &&
                      current.productId == productItem.id) ||
                  (current is SetFavoriteSuccess &&
                      current.productId == productItem.id) ||
                  (current is SetFavoriteError &&
                      current.productId == productItem.id),
              builder: (context, state) {
                if (state is SetFavoriteLoading) {
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }

                final isFav = state is SetFavoriteSuccess
                    ? state.isFavorite
                    : productItem.isFavorite;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => homeCubit.setFevorite(productItem),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppColors.red : AppColors.grey,
                    size: 22,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),

    const SizedBox(height: 6),

    /// اسم المنتج
    Text(
      productItem.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),

    /// الكاتيجوري
    Text(
      productItem.category,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 14,
        color: Colors.grey,
      ),
    ),

    /// السعر
    Text(
      '\$${productItem.price}',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    ),
  ],
);

  }
}
