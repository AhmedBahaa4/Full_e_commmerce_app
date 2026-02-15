import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/app_routes.dart';
import 'package:e_commerc_app/views/widgets/main_button.dart';
import 'package:e_commerc_app/views_models/cubit/payment_method_cubit/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodBottomSheetWidget extends StatelessWidget {
  const PaymentMethodBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paymentMethodCubit = BlocProvider.of<PaymentMethodsCubit>(context);

    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Selected Payment Method',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 BlocBuilder
              BlocBuilder(
                bloc: paymentMethodCubit,
                buildWhen: (previous, current) =>
                    current is FetchedPaymentMethodss ||
                    current is FetchedPaymentMethodsFailure ||
                    current is FetchingPaymentMethods,
                builder: (context, state) {
                  if (state is FetchingPaymentMethods) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is FetchedPaymentMethodss) {
                    final paymentCards = state.paymentCards;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentCards.length,
                      itemBuilder: (context, index) {
                        final paymentCard = paymentCards[index];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              paymentMethodCubit.changePaymentMethod(
                                paymentCard.id,
                              );
                            },
                            leading: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.grey3,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 6,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/250px-Mastercard-logo.svg.png',
                                  width: 70,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                ),
                              ),
                            ),
                            title: Text(paymentCard.cardHolderName),
                            subtitle: Text(
                              '**** **** **** ${paymentCard.cardNumber.substring(paymentCard.cardNumber.length - 4)}',
                            ),
                            trailing:
                                BlocBuilder<
                                  PaymentMethodsCubit,
                                  PaymentMethodsState
                                >(
                                  bloc: paymentMethodCubit,
                                  buildWhen: (previous, current) =>
                                      current is PaymentMethodChosen,
                                  builder: (context, state) {
                                    if (state is PaymentMethodChosen) {
                                      final chosenPayment = state.chosenPayment;

                                      return Radio<String>(
                                        value: paymentCard.id,
                                        // ignore: deprecated_member_use
                                        groupValue: chosenPayment.id,
                                        // ignore: deprecated_member_use
                                        onChanged: (id) {
                                          paymentMethodCubit
                                              .changePaymentMethod(id!);
                                        },
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                          ),
                        );
                      },
                    );
                  } else if (state is FetchedPaymentMethodsFailure) {
                    return Center(
                      child: Text(
                        'Error: ${state.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No payment methods available.'),
                    );
                  }
                },
              ),

              SizedBox(height: size.height * 0.02),

              // 🔹 زر إضافة كارت جديد
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(
                        AppRoutes.addNewCardRoute,
                        arguments: paymentMethodCubit,
                      )
                      .then((value) async {
                        await paymentMethodCubit.fetchPaymentMethods();
                      });
                },
                child: const Card(
                  color: AppColors.grey3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.grey3,
                      radius: 16,
                      child: Icon(Icons.add, color: AppColors.grey),
                    ),
                    title: Text(
                      'Add New Card',
                      style: TextStyle(
                        color: AppColors.black2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // 🔹 زر تأكيد الدفع
              BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                bloc: paymentMethodCubit,

                // 🔹 التحقق من متى يتم التحديث أو الاستماع
                listenWhen: (previous, current) =>
                    current is ConfirmPaymentSuccess,
                buildWhen: (previous, current) =>
                    current is ConfirmPaymentLoading ||
                    current is ConfirmPaymentSuccess ||
                    current is ConfirmPaymentFailure,

                // 🔹 listener
                listener: (context, state) {
                  if (state is ConfirmPaymentSuccess) {
                    Navigator.of(context).pop();
                  } else if (state is ConfirmPaymentFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Payment failed: ${state.message}'),
                      ),
                    );
                  }
                },

                // 🔹 builder
                builder: (context, state) {
                  if (state is ConfirmPaymentLoading) {
                    return MainButton(
                      isLoading: true,
                      textColor: AppColors.black2,
                      onTap: null,
                    );
                  }

                  return MainButton(
                    text: 'Confirm Payment',
                    textColor: AppColors.black2,
                    onTap: () {
                      paymentMethodCubit.confirmPaymentMethod();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
