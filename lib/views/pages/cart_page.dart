import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/widgets/cart_item_widget.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final cubit = BlocProvider.of<CartCubit>(context);
          return BlocBuilder<CartCubit, CartState>(
            bloc: cubit,
            buildWhen: (previous, current) =>
                current is CartLoaded ||
                current is CartLoading ||
                current is CartError,
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is CartLoaded) {
                final cartItems = state.cartItems;
                // If cart is empty
                if (cartItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          // ignore: deprecated_member_use
                          color: AppColors.black.withOpacity(0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start shopping and add items to your cart',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 14,
                                // ignore: deprecated_member_use
                                color: AppColors.black.withOpacity(0.6),
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final cartItem = cartItems[index];
                          return CartItemWidget(cartItem: cartItem);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(color: AppColors.greyshade),
                      ),
                      Divider(color: AppColors.greyshade),
                      BlocBuilder<CartCubit, CartState>(
                        bloc: cubit,
                        buildWhen: (previous, current) =>
                            current is SubTotalUpdated,
                        builder: (context, subTotalState) {
                          if (subTotalState is SubTotalUpdated) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                totalAndSubtotal(
                                  context,
                                  title: 'subtotal',
                                  amount: subTotalState.subTotal,
                                ),
                                const SizedBox(height: 4),
                                totalAndSubtotal(
                                  context,
                                  title: 'shipping',
                                  amount: state.shipping,
                                ),
                                const SizedBox(height: 5),
                                Dash(
                                  direction: Axis.horizontal,
                                  length: 360,
                                  dashLength: 5,
                                  dashColor: AppColors.grey5,
                                ),
                                const SizedBox(height: 5),
                                totalAndSubtotal(
                                  context,
                                  title: 'Total Amount',
                                  amount:
                                      subTotalState.subTotal + state.shipping,
                                ),
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              totalAndSubtotal(
                                context,
                                title: 'subtotal',
                                amount: state.subTotal,
                              ),
                              const SizedBox(height: 4),
                              totalAndSubtotal(
                                context,
                                title: 'shipping',
                                amount: state.shipping,
                              ),
                              const SizedBox(height: 5),
                              Dash(
                                direction: Axis.horizontal,
                                length: 360,
                                dashLength: 5,
                                dashColor: AppColors.grey5,
                              ),
                              const SizedBox(height: 5),
                              totalAndSubtotal(
                                context,
                                title: 'Total Amount',
                                amount: state.subTotal + state.shipping,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: SizedBox(
                          width: 360,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(AppRoutes.checkoutRoute);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fixedSize: const Size(360, 50),
                            ),
                            child: Text(
                              'checkout',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is CartError) {
                return const Center(child: Text('Error'));
              } else {
                return const Center(child: Text('Empty'));
              }
            },
          );
        },
      ),
    );
  }

  Widget totalAndSubtotal(
    context, {
    required String title,
    required double amount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
