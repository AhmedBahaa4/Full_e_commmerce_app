import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/widgets/label_with_textfield_widget.dart';
import 'package:e_commerc_app/views_models/cubit/payment_method_cubit/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PaymentMethodsCubit>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add New Card',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  LabelWithTextField(
                    label: 'Card Number',
                    controller: _cardNumberController,
                    prefixIcon: Icons.credit_card,
                    hintText: 'Enter Card Number',
                    obsecureText: false,
                    suffixIcon: null,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 5),
                  LabelWithTextField(
                    label: 'Card Holder Name',
                    controller: _cardHolderNameController,
                    prefixIcon: Icons.person,
                    hintText: 'Enter Card Holder Name',
                    obsecureText: false,
                    suffixIcon: null,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 5),
                  LabelWithTextField(
                    label: 'Expiry Date',
                    controller: _expiryDateController,
                    prefixIcon: Icons.calendar_month,
                    hintText: 'Enter Expiry Date',
                    obsecureText: false,
                    suffixIcon: null,
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 5),
                  LabelWithTextField(
                    label: 'CVV',
                    controller: _cvvController,
                    prefixIcon: Icons.pin,
                    hintText: 'Enter CVV',
                    obsecureText: true,
                    suffixIcon: null,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                    listenWhen: (previous, current) =>
                        current is AddNewCardSuccess ||
                        current is AddNewCardFailure,
                    listener: (context, state) {
                      if (state is AddNewCardSuccess) {
                        Navigator.pop(context);
                      } else if (state is AddNewCardFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Something went wrong')),
                        );
                      }
                    },
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is AddNewCardLoading ||
                        current is AddNewCardSuccess ||
                        current is AddNewCardFailure,
                    builder: (context, state) {
                      if (state is AddNewCardLoading) {
                        return ElevatedButton(
                          onPressed: () {
                            null;
                          },
                          child: const CircularProgressIndicator(
                            color: AppColors.white,
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.addNewCard(
                              _cardNumberController.text,
                              _expiryDateController.text,
                              _cvvController.text,
                              _cardHolderNameController.text,
                            );
                          }
                        },
                        child: Text(
                          'Add Card',

                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
