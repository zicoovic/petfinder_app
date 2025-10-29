import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/routing/app_routes.dart';
import '../../bloc/pet_cubit.dart';
import '../../bloc/pet_state.dart';
import '../../widgets/pet_card_list.dart';

class PetListView extends StatelessWidget {
  const PetListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is PetError) {
          return _buildError(context, state.message);
        } else if (state is PetLoaded) {
          if (state.pets.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: state.pets.length,
            itemBuilder: (context, index) {
              final pet = state.pets[index];
              return PetCardList(
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
          Icon(Icons.pets, size: 64.sp, color: AppColors.textLight),
          SizedBox(height: 16.h),
          Text('No pets found', style: AppTextStyles.bodyMedium(context)),
        ],
      ),
    );
  }
}