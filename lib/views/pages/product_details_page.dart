import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/product_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/widgets/product_couner_widget.dart';
import 'package:e_commerc_app/views_models/cubit/prodcut_details_page/product_deails_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<ProductDeailsCubit>(context);

    return BlocBuilder<ProductDeailsCubit, ProductDeailsState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is ProductDetailsLoaded ||
          current is ProductDetailsLoading ||
          current is ProductDetailsError,
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is ProductDetailsLoaded) {
          final product = state.product;

          return SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Product Details',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border_outlined),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: size.height * 0.52,
                      decoration: BoxDecoration(color: AppColors.greyshade),
                      child: Column(
                        children: [
                          const SizedBox(height: 35),
                          CachedNetworkImage(
                            imageUrl: product.imgUrl,
                            height: size.height * 0.4,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.4),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            topLeft: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: AppColors.yellow,
                                            size: 28,
                                          ),
                                          Text(
                                            product.averageRate.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.black,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // هنا استخدمنا ال ProductCounterWidget الجديد
                                  BlocBuilder<
                                    ProductDeailsCubit,
                                    ProductDeailsState
                                  >(
                                    bloc: cubit,
                                    buildWhen: (previous, current) =>
                                        current is QuantityCounterLoaded ||
                                        current is ProductDetailsLoaded,
                                    builder: (context, state) {
                                      int value = 1;
                                      if (state is QuantityCounterLoaded) {
                                        value = state.value;
                                      }
                                      return ProductCounterWidget(
                                        productId: product.id,
                                        value: value,
                                        cubit: cubit,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'sizes',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                              ),
                              BlocBuilder<
                                ProductDeailsCubit,
                                ProductDeailsState
                              >(
                                bloc: cubit,
                                buildWhen: (previous, current) =>
                                    current is SizeSelected ||
                                    current is ProductDetailsLoaded,
                                builder: (context, state) {
                                  return Row(
                                    children: ProductSize.values
                                        .map(
                                          (size) => Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4.0,
                                              right: 8.0,
                                            ),
                                            child: InkWell(
                                              onTap: () =>
                                                  cubit.selectSize(size),
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColors.white,
                                                  ),
                                                  color:
                                                      state is SizeSelected &&
                                                          state.size == size
                                                      ? AppColors.primary
                                                      : AppColors.grey3,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    size.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              AppColors.black2,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Description',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.description,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black2,
                                    ),
                              ),
                              const SizedBox(height: 70),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: '\$',
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: product.price.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.black,
                                              ),
                                        ),
                                      ],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.black,
                                        ),
                                  ),
                                  BlocBuilder<
                                    ProductDeailsCubit,
                                    ProductDeailsState
                                  >(
                                    bloc: cubit,
                                    buildWhen: (previous, current) =>
                                        current is ProductAddedToCart ||
                                        current is ProductAddingToCart,
                                    builder: (context, state) {
                                      if (state is ProductAddingToCart) {
                                        return ElevatedButton(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child:
                                              const CircularProgressIndicator.adaptive(),
                                        );
                                      } else if (state is ProductAddedToCart) {
                                        return ElevatedButton(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: const Text('Added to Cart'),
                                        );
                                      }
                                      return ElevatedButton.icon(
                                        onPressed: () {
                                          if (cubit.selectedSize != null) {
                                            cubit.addToCart(product.id);
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Please select a size',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        label: Text(
                                          'Add to Cart',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.white,
                                              ),
                                        ),
                                        icon: const Icon(
                                          Icons.shopping_bag_outlined,
                                          size: 24,
                                          color: AppColors.white,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: AppColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ProductDetailsError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }
      },
    );
  }
}
