import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views_models/cubit/fav_cubit/favorite_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritCubit = BlocProvider.of<FavoriteCubit>(context);

    return BlocBuilder<FavoriteCubit, FavoriteCubitState>(
      bloc: favoritCubit,
      buildWhen: (previous, current) =>
          current is FavoriteLoaded ||
          current is FavoriteError ||
          current is FavoriteLoading,
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is FavoriteLoaded) {
          final favoritProduct = state.favoriteProducts;

          if (favoritProduct.isEmpty) {
            return const Center(
              child: Text(
                'No favorite products yet ❤️',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await favoritCubit.getFavoriteProducts();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              separatorBuilder: (context, index) => const Divider(
                indent: 16,
                endIndent: 16,
                thickness: 1,
                color: AppColors.grey,
              ),
              itemCount: favoritProduct.length,
              itemBuilder: (BuildContext context, int index) {
                final product = favoritProduct[index];

                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.imgUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '\$${product.price}',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: BlocConsumer<FavoriteCubit, FavoriteCubitState>(
                      bloc: favoritCubit,
                      listener: (context, state) {
                        if (state is FavoriteRmovevEror) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              closeIconColor: AppColors.primary,
                            ),
                          );
                        } else if (state is FavoriteRmoved) {}
                      },
                      buildWhen: (previous, current) =>
                          (current is FavoriteRmoveving &&
                              current.productId == product.id) ||
                          (current is FavoriteRmoved &&
                              current.productId == product.id) ||
                          (current is FavoriteRmovevEror),

                      builder: (context, state) {
                        if (state is FavoriteRmoveving &&
                            state.productId == product.id) {
                          return const CircularProgressIndicator.adaptive();
                        } else if (state is FavoriteRmoved &&
                            state.productId == product.id) {
                          return const Icon(Icons.done, color: Colors.green);
                        }

                        // 👇 هنا المشكلة كانت.. لازم ارجع الآيكون الأساسية مش لودينج
                        return IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            favoritCubit.removeFavorite(product.id);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is FavoriteError) {
          return const Center(
            child: Text(
              'Something went wrong 😢',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
