import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/models/payment_card_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/widgets/checkout_headlines_item.dart';
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

  Widget _buildPaymentMethodItem(
    PaymentCardModel? chosenCard,
    BuildContext context,
  ) {
    final checkoutCubit = BlocProvider.of<CheckOutCubit>(context);
    // final paymentMethodsCubit = BlocProvider.of<PaymentMethodsCubit>(context);
    BlocProvider.of<PaymentMethodsCubit>(context);
    if (chosenCard != null) {
      return PaymentMethodItem(
        paymentCard: chosenCard,

        onItemTapped: () {
          showModalBottomSheet(
            backgroundColor: AppColors.white,
            elevation: 8,

            context: context,
            isScrollControlled: true,

            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return BlocProvider(
                create: (context) =>
                    PaymentMethodsCubit()..fetchPaymentMethods(),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.55,

                  child: const PaymentMethodBottomSheetWidget(),
                ),
              );
            },
            isDismissible: true,
            enableDrag: true,
          ).then((_) async {
            // ignore: use_build_context_synchronously
            await checkoutCubit.getCheckoutContent();
          });
        },
      );
    } else {
      return const EmptyShippingPayment(
        title: 'Add Payment Method',
        isPayment: true,
      );
    }
  }

  Widget _buildShipingItem(
    LocationItemModel? chosenAdress,
    BuildContext context,
  ) {
    if (chosenAdress != null) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: CachedNetworkImage(
              imageUrl: chosenAdress.imgurl,
              width: 140,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chosenAdress.city,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(color: AppColors.black),
              ),
              const SizedBox(width: 24),
              Text(
                '${chosenAdress.city}-${chosenAdress.country}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ],
      );
    } else {
      return const EmptyShippingPayment(
        title: 'Add shiping address',
        isPayment: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CheckOutCubit>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Checkout',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        // استخدمت body + bottom padding بدل fixed-size button داخل body
        body: BlocBuilder<CheckOutCubit, CheckOutState>(
          bloc: cubit,
          buildWhen: (previous, current) =>
              current is CheckOutLoaded ||
              current is CheckOutLoading ||
              current is CheckOutError,
          builder: (context, state) {
            if (state is CheckOutLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is CheckOutError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            } else if (state is CheckOutLoaded) {
              final choosenpaymentCards = state.choosenpaymentCard;
              final cartItems = state.cartItems;
              final total = state.totalAmount;
              final chosenAdress = state.chosenAdress;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address section (تقدر تستبدل بـ AddressPicker اللي اتفقنا عليه)
                    CheckoutHeadlinesItem(
                      title: 'Address',
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.chooseLocation)
                            .then((value) => cubit.getCheckoutContent());
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildShipingItem(chosenAdress, context),
                    const SizedBox(height: 16),
                    CheckoutHeadlinesItem(
                      title: 'Product',
                      numOfItems: state.numberOfProducts,
                    ),
                    const SizedBox(height: 12),

                    // List of cart items
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // الصورة
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.greyshade,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: item.product.imgUrl,
                                    width: 92,
                                    height: 92,
                                    fit: BoxFit.cover,
                                    placeholder: (c, u) => Container(
                                      width: 92,
                                      height: 92,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    errorWidget: (c, u, e) => Container(
                                      width: 92,
                                      height: 92,
                                      alignment: Alignment.center,
                                      color: AppColors.greyshade,
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // اسم المنتج + details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Size: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors.black2,
                                                    fontSize: 14,
                                                  ),
                                              children: [
                                                TextSpan(
                                                  text: item.size
                                                      .toString()
                                                      .split('.')
                                                      .last
                                                      .toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: AppColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${item.product.price.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: AppColors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    //
                                    const SizedBox(height: 12),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Quantity: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.black2,
                                              fontSize: 14,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: item.quantity.toString(),

                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // Payment method headline
                    Text(
                      ' Payment Method',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Total container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: AppColors.greyshade.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppColors.grey, fontSize: 16),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // const EmptyShippingPayment(title: 'Add Payment Method'),
                    _buildPaymentMethodItem(choosenpaymentCards, context),
                    // const SizedBox(height: 16),

                    // const SizedBox(height: 20),

                    // spacer bottom so scroll doesn't hide last content under button
                    const SizedBox(height: kToolbarHeight + 20),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),

        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            MediaQuery.of(context).viewPadding.bottom + 12,
          ),
          child: MainButton(text: 'Proceed to Pay', onTap: () {}),
        ),
      ),
    );
  }
}
