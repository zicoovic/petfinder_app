import 'package:flutter/material.dart';
import '../../../core/entities/pet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AdoptDialog {
  static void show(BuildContext context, Pet pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adopt ${pet.name}?', style: AppTextStyles.heading3),
        content: Text(
          'Are you sure you want to adopt ${pet.name}?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Congratulations! ${pet.name} is yours!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: Text('Adopt', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}