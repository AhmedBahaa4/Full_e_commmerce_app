import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/utils/responsive_helper.dart';
import 'package:e_commerc_app/views/widgets/main_button.dart';
import 'package:e_commerc_app/views_models/cubit/payment_method_cubit/payment_method_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_onFormChanged);
    _cardHolderNameController.addListener(_onFormChanged);
    _expiryDateController.addListener(_onFormChanged);
    _cvvController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_onFormChanged);
    _cardHolderNameController.removeListener(_onFormChanged);
    _expiryDateController.removeListener(_onFormChanged);
    _cvvController.removeListener(_onFormChanged);
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String get _maskedCardNumber {
    final digits = _cardNumberController.text.replaceAll(' ', '');
    if (digits.isEmpty) return '**** **** **** ****';
    final visible = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : digits;
    return '**** **** **** ${visible.padLeft(4, '*')}';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PaymentMethodsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Payment Card',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
          listener: (context, state) {
            if (state is AddNewCardSuccess) {
              Navigator.of(context).pop();
            } else if (state is AddNewCardFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          buildWhen: (previous, current) =>
              current is AddNewCardLoading ||
              current is AddNewCardSuccess ||
              current is AddNewCardFailure,
          builder: (context, state) {
            final isLoading = state is AddNewCardLoading;

            return LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = ResponsiveHelper.maxContentWidth(context);
                final horizontalPadding = ResponsiveHelper.horizontalPadding(
                  context,
                );

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          16,
                          horizontalPadding,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CardPreview(
                              cardNumber: _maskedCardNumber,
                              holderName: _cardHolderNameController.text.isEmpty
                                  ? 'Card Holder'
                                  : _cardHolderNameController.text
                                        .toUpperCase(),
                              expiryDate: _expiryDateController.text.isEmpty
                                  ? 'MM/YY'
                                  : _expiryDateController.text,
                            ),
                            const SizedBox(height: 20),
                            _CardInputField(
                              label: 'Card Number',
                              hintText: '1234 5678 9012 3456',
                              controller: _cardNumberController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                                const _CardNumberFormatter(),
                              ],
                              prefixIcon: Icons.credit_card_rounded,
                              validator: (value) {
                                final digits = (value ?? '').replaceAll(
                                  ' ',
                                  '',
                                );
                                if (digits.length < 16) {
                                  return 'Enter a valid card number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _CardInputField(
                              label: 'Card Holder Name',
                              hintText: 'Ahmed Bahaa',
                              controller: _cardHolderNameController,
                              keyboardType: TextInputType.name,
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter card holder name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _CardInputField(
                                    label: 'Expiry Date',
                                    hintText: 'MM/YY',
                                    controller: _expiryDateController,
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icons.calendar_month_outlined,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      const _ExpiryDateFormatter(),
                                    ],
                                    validator: (value) {
                                      final text = value ?? '';
                                      final valid = RegExp(
                                        r'^(0[1-9]|1[0-2])\/\d{2}$',
                                      ).hasMatch(text);
                                      if (!valid) {
                                        return 'MM/YY';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _CardInputField(
                                    label: 'CVV',
                                    hintText: '123',
                                    controller: _cvvController,
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    validator: (value) {
                                      final length = (value ?? '').length;
                                      if (length < 3) {
                                        return 'Invalid CVV';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            MainButton(
                              text: 'Save Card',
                              isLoading: isLoading,
                              onTap: () {
                                if (!_formKey.currentState!.validate()) return;
                                cubit.addNewCard(
                                  _cardNumberController.text.replaceAll(
                                    ' ',
                                    '',
                                  ),
                                  _expiryDateController.text.trim(),
                                  _cvvController.text.trim(),
                                  _cardHolderNameController.text.trim(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  final String cardNumber;
  final String holderName;
  final String expiryDate;

  const _CardPreview({
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF111A46), Color(0xFF6039D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.credit_card, color: AppColors.white),
              ),
              const Spacer(),
              const Text(
                'VISA',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            cardNumber,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 22,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _PreviewLabel(title: 'Card Holder', value: holderName),
              ),
              _PreviewLabel(title: 'Expires', value: expiryDate),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewLabel extends StatelessWidget {
  final String title;
  final String value;

  const _PreviewLabel({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CardInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final IconData prefixIcon;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const _CardInputField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    required this.prefixIcon,
    this.obscureText = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.grey2,
            prefixIcon: Icon(prefixIcon, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  const _CardNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (var index = 0; index < digitsOnly.length; index++) {
      if (index > 0 && index % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digitsOnly[index]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  const _ExpiryDateFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll('/', '');
    if (digitsOnly.length <= 2) {
      return newValue.copyWith(
        text: digitsOnly,
        selection: TextSelection.collapsed(offset: digitsOnly.length),
      );
    }
    final month = digitsOnly.substring(0, 2);
    final year = digitsOnly.substring(2);
    final text = '$month/$year';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
