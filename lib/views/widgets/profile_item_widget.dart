import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class ProfileItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ProfileItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.textColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColors.black),
        title: Text(
          title,
          style: TextStyle(color: textColor ??  AppColors.black, fontWeight: FontWeight.bold),
        ),
        trailing: trailingText != null
            ? Text(                trailingText!,
                style: const TextStyle(color: AppColors.grey , fontWeight: FontWeight.bold),
              )
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap, // ✅ دي التعديل المهم
      ),
    );
  }
}
