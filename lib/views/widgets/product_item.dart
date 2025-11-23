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
    return Column(
      children: [
        Stack(
          children: [
            Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.greyshade),
                  child: CachedNetworkImage(
                    imageUrl: productItem.imgUrl,
                    height: 115,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red, size: 40),
                  ),
                ),
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
                        return const CircularProgressIndicator();
                      } else if (state is SetFavoriteError) {
                        return const Icon(Icons.favorite_border , color: AppColors.black,);
                      } else if (state is SetFavoriteSuccess) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async => homeCubit.setFevorite(productItem),
                          child: Icon(
                            state.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: state.isFavorite
                                ? AppColors.red
                                : AppColors.grey,
                            size: 40,
                          ),
                        );
                      }

                      return GestureDetector(
                        behavior: HitTestBehavior
                            .opaque, // ← مهم علشان يمنع اللمسة تروح للـ parent
                        onTap: () async => homeCubit.setFevorite(productItem),
                        child: Icon(
                          productItem.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: productItem.isFavorite
                              ? AppColors.red
                              : AppColors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        Text(
          productItem.name,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.black,
          ),
        ),

        Text(
          productItem.category,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w300,
            fontSize: 15,
            color: AppColors.grey,
          ),
        ),

        Text(
          '\$${productItem.price}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
