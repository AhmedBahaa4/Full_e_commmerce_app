import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
import 'package:e_commerc_app/views/widgets/cart_item_widget.dart';
import 'package:e_commerc_app/views_models/cubit/cart_cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) =>
              current is CartLoaded ||
              current is CartLoading ||
              current is CartError,
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state is CartError) {
              return _CartErrorView(
                message: state.message,
                onRetry: () => cubit.getCartItems(),
              );
            }

            if (state is! CartLoaded) {
              return const SizedBox.shrink();
            }

            if (state.cartItems.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => cubit.getCartItems(showLoading: false),
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
                    const _CartEmptyView(),
                  ],
                ),
              );
            }

            final totalItems = state.cartItems.fold<int>(
              0,
              (sum, item) => sum + item.quantity,
            );

            return RefreshIndicator(
              onRefresh: () => cubit.getCartItems(showLoading: false),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxContentWidth = ResponsiveHelper.maxContentWidth(
                    context,
                  );
                  final horizontalPadding = ResponsiveHelper.horizontalPadding(
                    context,
                  );

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          16,
                          horizontalPadding,
                          34,
                        ),
                        children: [
                          _CartHeader(
                            totalItems: totalItems,
                            totalAmount: state.subTotal + state.shipping,
                          ),
                          const SizedBox(height: 18),
                          ...state.cartItems.map(
                            (item) => CartItemWidget(cartItem: item),
                          ),
                          const SizedBox(height: 8),
                          _SummaryCard(
                            subTotal: state.subTotal,
                            shipping: state.shipping,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(AppRoutes.checkoutRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.lock_outline_rounded),
                              label: const Text(
                                'Secure Checkout',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

class _CartHeader extends StatelessWidget {
  final int totalItems;
  final double totalAmount;

  const _CartHeader({required this.totalItems, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF6741D9), Color(0xFF8A63FF)],
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
              Icons.shopping_bag_outlined,
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
                  'Your Cart',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalItems items',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double subTotal;
  final double shipping;

  const _SummaryCard({required this.subTotal, required this.shipping});

  @override
  Widget build(BuildContext context) {
    final total = subTotal + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: subTotal),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Shipping', value: shipping),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.grey5),
          ),
          _SummaryRow(label: 'Total', value: total, highlight: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: highlight ? AppColors.black : AppColors.black2,
      fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textStyle),
        Text('\$${value.toStringAsFixed(2)}', style: textStyle),
      ],
    );
  }
}

class _CartEmptyView extends StatelessWidget {
  const _CartEmptyView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 78,
          width: 78,
          decoration: BoxDecoration(
            color: AppColors.grey2,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
            size: 40,
            color: AppColors.black2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your cart is empty',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pull down to refresh after adding products.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.black2),
        ),
      ],
    );
  }
}

class _CartErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CartErrorView({required this.message, required this.onRetry});

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
              'Could not load cart',
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
