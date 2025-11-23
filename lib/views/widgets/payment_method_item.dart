import 'package:cached_network_image/cached_network_image.dart';
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
    return InkWell(
      onTap: onItemTapped,
      child: DecoratedBox(
       
        decoration: BoxDecoration(
         
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
          border: Border.all(color: AppColors.grey3),
        ),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/250px-Mastercard-logo.svg.png',
            width: 70,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red, size: 40),
          ),
          title: const Text(
            'MasterCard',
            style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '**** **** **** ${paymentCard.cardNumber.substring(paymentCard.cardNumber.length - 4)}',
            style: const TextStyle(color: AppColors.grey),
          ),
          trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
        ),
      ),
    );
  }
}
