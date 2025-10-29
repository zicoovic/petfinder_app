import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/routing/app_routes.dart';
import '../../bloc/pet_cubit.dart';
import '../../bloc/pet_state.dart';
import '../../widgets/pet_card_grid.dart';

class AdoptedGridView extends StatelessWidget {
  const AdoptedGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is PetError) {
          return _buildError(context, state.message);
        } else if (state is PetLoaded) {
          final adoptedPets = state.pets.where((pet) => pet.isAdopted).toList();

          if (adoptedPets.isEmpty) {
            return _buildEmptyState(context);
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: adoptedPets.length,
            itemBuilder: (context, index) {
              final pet = adoptedPets[index];
              return PetCardGrid(
                pet: pet,
                onTap: () => context.push(AppRoutes.details, extra: pet),
                onFavoriteTap: () {
                  context.read<PetCubit>().toggleFavoriteStatus(pet);
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(message, style: AppTextStyles.bodyMedium(context)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.volunteer_activism,
            size: 80.sp,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          SizedBox(height: 16.h),
          Text('No Adopted Pets Yet', style: AppTextStyles.heading3(context)),
          SizedBox(height: 8.h),
          Text(
            'Start adopting pets to see them here!',
            style: AppTextStyles.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}