import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/widgets/cart_couner_widget.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final AddToCartModel cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CartCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // صورة المنتج
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.greyshade,
              borderRadius: BorderRadius.circular(16),
              shape: BoxShape.rectangle,
            ),
            child: CachedNetworkImage(
              imageUrl: cartItem.product.imgUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red, size: 40),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  height: 25,
                  child: Text(
                    cartItem.product.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                Text.rich(
                  TextSpan(
                    text: 'Size: ',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.black2,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text:
                            ' ${cartItem.size.toString().split('.').last.toUpperCase()}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                BlocBuilder<CartCubit, CartState>(
                  bloc: cubit,
                  buildWhen: (previous, current) =>
                      current is QuantityCounterLoaded &&
                      current.productId == cartItem.product.id,

                  builder: (context, state) {
                    if (state is QuantityCounterLoaded) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CartCounterWidget(
                            cartItem: cartItem,
                            value: state.value,
                            cubit: cubit,
                          ),

                          Text(
                            '\$ ${(state.value * cartItem.product.price).toStringAsFixed(1)}',

                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      );
                    }
                   return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    CartCounterWidget(
      cartItem: cartItem,
      value: cartItem.quantity,
      cubit: cubit,
    ),
    Text(
      '\$ ${cartItem.totalPrice.toStringAsFixed(1)}',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
);

                  },
                ),
              ],
            ),
          ),

          // السعر
        ],
      ),
    );
  }
}
