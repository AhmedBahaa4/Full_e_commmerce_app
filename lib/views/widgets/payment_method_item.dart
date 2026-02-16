import 'package:e_commerc_app/models/payment_card_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class PaymentMethodItem extends StatelessWidget {
  final PaymentCardModel paymentCard;
  final VoidCallback onItemTapped;

  const PaymentMethodItem({
    super.key,
    required this.paymentCard,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final cardNumber = paymentCard.cardNumber.trim();
    final suffix = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onItemTapped,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.white,
          border: Border.all(color: AppColors.grey5),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.credit_card_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentCard.cardHolderName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '**** **** **** $suffix',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
