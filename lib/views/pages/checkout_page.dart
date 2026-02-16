import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/add_to_cart_model.dart';
import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/models/payment_card_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
import 'package:e_commerc_app/views/widgets/empty_shipping_payment.dart';
import 'package:e_commerc_app/views/widgets/main_button.dart';
import 'package:e_commerc_app/views/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:e_commerc_app/views/widgets/payment_method_item.dart';
import 'package:e_commerc_app/views_models/cubit/check_out_cubit/check_out_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/payment_method_cubit/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  Future<void> _openAddress(BuildContext context, CheckOutCubit cubit) async {
    await Navigator.of(context).pushNamed(AppRoutes.chooseLocation);
    if (!context.mounted) return;
    await cubit.getCheckoutContent();
  }

  Future<void> _openPaymentMethods(
    BuildContext context,
    CheckOutCubit checkoutCubit,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      elevation: 8,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider(
          create: (context) => PaymentMethodsCubit()..fetchPaymentMethods(),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.62,
            child: const PaymentMethodBottomSheetWidget(),
          ),
        );
      },
    );
    if (!context.mounted) return;
    await checkoutCubit.getCheckoutContent();
  }

  Future<void> _handleProceedToPay(
    BuildContext context,
    CheckOutLoaded state,
    CheckOutCubit cubit,
  ) async {
    if (state.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty. Add products first.'),
        ),
      );
      return;
    }

    if (state.chosenAdress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a shipping address first.')),
      );
      await _openAddress(context, cubit);
      return;
    }

    if (state.choosenpaymentCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a payment method first.')),
      );
      await _openPaymentMethods(context, cubit);
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator.adaptive()),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!context.mounted) return;
    Navigator.of(context).pop();

    final goHome = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text(
          'Your order of \$${state.totalAmount.toStringAsFixed(2)} has been placed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay Here'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Go Home'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    if (goHome == true) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamedAndRemoveUntil(AppRoutes.homeroute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckOutCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<CheckOutCubit, CheckOutState>(
          buildWhen: (previous, current) =>
              current is CheckOutLoading ||
              current is CheckOutLoaded ||
              current is CheckOutError,
          builder: (context, state) {
            if (state is CheckOutLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state is CheckOutError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        state.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => cubit.getCheckoutContent(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is! CheckOutLoaded) {
              return const SizedBox.shrink();
            }

            return RefreshIndicator(
              onRefresh: () => cubit.getCheckoutContent(),
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
                          140,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          _CheckoutHeaderCard(
                            totalAmount: state.totalAmount,
                            itemCount: state.numberOfProducts,
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(
                            title: 'Shipping Address',
                            actionText: 'Edit',
                            onActionTap: () => _openAddress(context, cubit),
                          ),
                          const SizedBox(height: 10),
                          _AddressSection(
                            address: state.chosenAdress,
                            onAddAddress: () => _openAddress(context, cubit),
                          ),
                          const SizedBox(height: 16),
                          _SectionTitle(
                            title: 'Products (${state.numberOfProducts})',
                          ),
                          const SizedBox(height: 10),
                          ...state.cartItems.map(_CheckoutProductItem.new),
                          const SizedBox(height: 16),
                          const _SectionTitle(title: 'Payment Method'),
                          const SizedBox(height: 10),
                          _PaymentSection(
                            chosenCard: state.choosenpaymentCard,
                            onChoosePayment: () =>
                                _openPaymentMethods(context, cubit),
                          ),
                          const SizedBox(height: 16),
                          _SummaryCard(totalAmount: state.totalAmount),
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
      bottomNavigationBar: BlocBuilder<CheckOutCubit, CheckOutState>(
        buildWhen: (previous, current) =>
            current is CheckOutLoading ||
            current is CheckOutLoaded ||
            current is CheckOutError,
        builder: (context, state) {
          final loadedState = state is CheckOutLoaded ? state : null;
          return Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.viewPaddingOf(context).bottom + 12,
            ),
            child: MainButton(
              text: loadedState == null
                  ? 'Proceed to Pay'
                  : 'Proceed to Pay \$${loadedState.totalAmount.toStringAsFixed(2)}',
              isLoading: state is CheckOutLoading,
              onTap: loadedState == null
                  ? null
                  : () => _handleProceedToPay(context, loadedState, cubit),
            ),
          );
        },
      ),
    );
  }
}

class _CheckoutHeaderCard extends StatelessWidget {
  final double totalAmount;
  final int itemCount;

  const _CheckoutHeaderCard({
    required this.totalAmount,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF6039D8), Color(0xFF8E62FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
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
                  'Order Overview',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$itemCount item(s)',
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
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const _SectionTitle({required this.title, this.actionText, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (actionText != null && onActionTap != null)
          TextButton(onPressed: onActionTap, child: Text(actionText!)),
      ],
    );
  }
}

class _AddressSection extends StatelessWidget {
  final LocationItemModel? address;
  final VoidCallback onAddAddress;

  const _AddressSection({required this.address, required this.onAddAddress});

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return const EmptyShippingPayment(
        title: 'Add shipping address',
        isPayment: false,
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: address!.imgurl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  const Icon(Icons.location_city_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address!.city,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${address!.city}, ${address!.country}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.black2),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onAddAddress,
            icon: const Icon(Icons.edit_location_alt_outlined),
          ),
        ],
      ),
    );
  }
}

class _CheckoutProductItem extends StatelessWidget {
  final AddToCartModel cartItem;

  const _CheckoutProductItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: cartItem.product.imgUrl,
              width: 74,
              height: 74,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image_not_supported_outlined),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size ${cartItem.size.name.toUpperCase()} • Qty ${cartItem.quantity}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
                ),
              ],
            ),
          ),
          Text(
            '\$${cartItem.totalPrice.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PaymentSection extends StatelessWidget {
  final PaymentCardModel? chosenCard;
  final VoidCallback onChoosePayment;

  const _PaymentSection({
    required this.chosenCard,
    required this.onChoosePayment,
  });

  @override
  Widget build(BuildContext context) {
    if (chosenCard == null) {
      return const EmptyShippingPayment(
        title: 'Add payment method',
        isPayment: true,
      );
    }

    return PaymentMethodItem(
      paymentCard: chosenCard!,
      onItemTapped: onChoosePayment,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double totalAmount;

  const _SummaryCard({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final shipping = totalAmount > 0 ? 10.0 : 0.0;
    final subTotal = totalAmount - shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
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
          _SummaryRow(label: 'Total', value: totalAmount, isTotal: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: isTotal ? AppColors.black : AppColors.black2,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('\$${value.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}
