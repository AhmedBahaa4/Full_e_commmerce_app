import 'package:e_commerc_app/utils/app_color.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading;
  MainButton({
    super.key,
    this.text,
    this.onTap,
    this.height = 50,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.isLoading = false,
  }) {
    assert(text != null || isLoading == true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          if (!isLoading) {
            onTap?.call();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Text(
                text!,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 18,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
