import 'package:flutter/material.dart';
import '../../core/entities/pet.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/details_header.dart';
import 'widgets/pet_image.dart';
import 'widgets/pet_info_card.dart';
import 'widgets/adopt_button.dart';

/// Details screen - Shows pet details
class DetailsScreen extends StatelessWidget {
  final Pet pet;

  const DetailsScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: Column(
          children: [
            DetailsHeader(pet: pet),
            Expanded(flex: 3, child: PetImage(pet: pet)),
            Expanded(
              flex: 4,
              child: PetInfoCard(
                pet: pet,
                onAdoptTap: () => AdoptDialog.show(context, pet),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
