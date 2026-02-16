// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/widgets/product_couner_widget.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/fav_cubit/favorite_cubit_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/home_cubit/home_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/prodcut_details_page/product_deails_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDeailsCubit>();

    return BlocConsumer<ProductDeailsCubit, ProductDeailsState>(
      listenWhen: (previous, current) =>
          current is ProductAddedToCart || current is ProductAddedToCartError,
      listener: (context, state) {
        if (state is ProductAddedToCart) {
          context.read<CartCubit>().getCartItems(showLoading: false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to cart successfully')),
          );
        } else if (state is ProductAddedToCartError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is ProductDetailsLoading && cubit.loadedProduct == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (state is ProductDetailsError && cubit.loadedProduct == null) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        final product = state is ProductDetailsLoaded
            ? state.product
            : cubit.loadedProduct;

        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        final isAdding = state is ProductAddingToCart;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.white,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: _ProductHero(imageUrl: product.imgUrl),
                ),
                title: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [_FavoriteAppBarButton(product: product)],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NameAndRate(product: product),
                      const SizedBox(height: 18),
                      Text(
                        'Select Size',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: ProductSize.values
                            .map(
                              (size) => ChoiceChip(
                                label: Text(size.name.toUpperCase()),
                                selected: cubit.selectedSize == size,
                                onSelected: (_) => cubit.selectSize(size),
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: cubit.selectedSize == size
                                      ? AppColors.white
                                      : AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                side: BorderSide(
                                  color: cubit.selectedSize == size
                                      ? AppColors.primary
                                      : AppColors.grey5,
                                ),
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.grey2,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Quantity',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Spacer(),
                            ProductCounterWidget(
                              productId: product.id,
                              value: cubit.quantity,
                              cubit: cubit,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black2,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.grey5),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 16,
                    offset: Offset(0, 6),
                    color: Color(0x1F000000),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(
                            color: AppColors.black2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\$${(product.price * cubit.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: isAdding
                          ? null
                          : () {
                              if (cubit.selectedSize == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please select size first'),
                                  ),
                                );
                                return;
                              }
                              cubit.addToCart(product.id);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: isAdding
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : const Icon(Icons.shopping_bag_outlined),
                      label: Text(
                        isAdding ? 'Adding...' : 'Add To Cart',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProductHero extends StatelessWidget {
  final String imageUrl;

  const _ProductHero({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4F1FF), Color(0xFFE8E0FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          width: MediaQuery.sizeOf(context).width * 0.65,
          placeholder: (context, _) =>
              const CircularProgressIndicator.adaptive(),
          errorWidget: (context, _, __) =>
              const Icon(Icons.image_not_supported_outlined, size: 50),
        ),
      ),
    );
  }
}

class _NameAndRate extends StatelessWidget {
  final ProductItemModel product;

  const _NameAndRate({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.yellow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: AppColors.orange, size: 18),
              const SizedBox(width: 4),
              Text(
                product.averageRate.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FavoriteAppBarButton extends StatelessWidget {
  final ProductItemModel product;

  const _FavoriteAppBarButton({required this.product});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          (current is SetFavoriteLoading && current.productId == product.id) ||
          (current is SetFavoriteSuccess && current.productId == product.id) ||
          (current is SetFavoriteError && current.productId == product.id) ||
          current is HomeLoaded,
      builder: (context, state) {
        final isLoading =
            state is SetFavoriteLoading && state.productId == product.id;
        final isFavorite =
            homeCubit.findProductById(product.id)?.isFavorite ??
            product.isFavorite;

        return IconButton(
          onPressed: isLoading
              ? null
              : () async {
                  final sourceProduct =
                      homeCubit.findProductById(product.id) ?? product;
                  await homeCubit.setFevorite(sourceProduct);
                  if (!context.mounted) return;
                  await context.read<FavoriteCubit>().getFavoriteProducts(
                    showLoading: false,
                  );
                },
          icon: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_outlined,
                  color: isFavorite ? AppColors.red : AppColors.black,
                ),
        );
      },
    );
  }
}
