import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class SocialMediaBottom extends StatelessWidget {
  final String? imgurl;
  final String? text;
  final VoidCallback? onTap;
  final bool isLoading;

  const SocialMediaBottom({
    super.key,
    this.imgurl,
    this.text,
    this.onTap,
    this.isLoading = false,
  }) : assert(
         (imgurl != null && text != null && onTap != null) || isLoading == true,
         'Either provide imgurl, text, and onTap, or set isLoading to true',
       );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imgurl != null)
                      CachedNetworkImage(
                        imageUrl: imgurl!,
                        width: 35,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                    const SizedBox(width: 12),
                    if (text != null)
                      Text(
                        text!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
