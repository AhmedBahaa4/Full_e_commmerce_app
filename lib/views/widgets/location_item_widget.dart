import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/models/location_item_model.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class LocationItemWidget extends StatelessWidget {
  final Color borderColor;
  final VoidCallback onTap;
  final LocationItemModel location;

  const LocationItemWidget({
    super.key,
    this.borderColor = AppColors.grey,
    required this.onTap,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = borderColor == AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey5,
            width: isSelected ? 1.6 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: location.imgurl,
                width: 64,
                height: 64,
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
                    location.city,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${location.city}, ${location.country}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.black2),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.primary : AppColors.grey4,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
