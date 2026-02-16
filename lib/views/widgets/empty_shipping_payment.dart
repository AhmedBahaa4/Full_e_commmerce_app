import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views_models/cubit/check_out_cubit/check_out_cubit.dart';
import 'package:e_commerc_app/views_models/cubit/payment_method_cubit/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyShippingPayment extends StatelessWidget {
  final String title;
  final bool isPayment;

  const EmptyShippingPayment({
    super.key,
    required this.title,
    required this.isPayment,
  });

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = context.read<CheckOutCubit>();
    final paymentMethodsCubit = context.read<PaymentMethodsCubit>();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        if (isPayment) {
          Navigator.of(context)
              .pushNamed(
                AppRoutes.addNewCardRoute,
                arguments: paymentMethodsCubit,
              )
              .then((value) async {
                await checkoutCubit.getCheckoutContent();
              });
          return;
        }

        Navigator.of(context).pushNamed(AppRoutes.chooseLocation).then((
          value,
        ) async {
          await checkoutCubit.getCheckoutContent();
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.grey2,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.grey5),
        ),
        child: Column(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isPayment
                    ? Icons.account_balance_wallet_outlined
                    : Icons.add_location_alt_outlined,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
