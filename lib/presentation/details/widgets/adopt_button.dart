import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/entities/pet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../bloc/pet_cubit.dart';

class AdoptDialog {
  static void show(BuildContext context, Pet pet) {
    final isAdopted = pet.isAdopted;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isAdopted ? 'Unadopt ${pet.name}?' : 'Adopt ${pet.name}?',
          style: AppTextStyles.heading3(context),
        ),
        content: Text(
          isAdopted
              ? 'Are you sure you want to unadopt ${pet.name}?'
              : 'Are you sure you want to adopt ${pet.name}?',
          style: AppTextStyles.bodyMedium(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              if (isAdopted) {
                await context.read<PetCubit>().unAdoptPet(pet);
                if (context.mounted) {
                  // Navigate back to close the details screen
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${pet.name} has been unadopted'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              } else {
                await context.read<PetCubit>().adoptPet(pet);
                if (context.mounted) {
                  // Navigate back to close the details screen
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Congratulations! ${pet.name} is yours!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              }
            },
            child: Text(
              isAdopted ? 'Unadopt' : 'Adopt',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}