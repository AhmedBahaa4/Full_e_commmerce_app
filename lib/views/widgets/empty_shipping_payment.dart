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
    final checkoutCubit = BlocProvider.of<CheckOutCubit>(context);
    final paymentMethodsCubit = BlocProvider.of<PaymentMethodsCubit>(context);
    return InkWell(
      onTap: () {
        if (isPayment == true) {
          Navigator.of(context)
              .pushNamed(
                AppRoutes.addNewCardRoute,
                arguments: paymentMethodsCubit,
              )
              .then((value) async {
                await checkoutCubit.getCheckoutContent();
              });
        } else {
          Navigator.of(context).pushNamed(AppRoutes.chooseLocation);
        }
      },
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: AppColors.grey3,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          child: Column(
            children: [
              const Icon(Icons.add),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
