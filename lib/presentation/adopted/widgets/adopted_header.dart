import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../bloc/pet_cubit.dart';

class AdoptedHeader extends StatelessWidget {
  const AdoptedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final cubit = context.read<PetCubit>();
              context.pop();
              // Reload pets after going back to home
              cubit.loadPets();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 24.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Your Adopted Pets',
            style: AppTextStyles.heading2(context),
          ),
        ],
      ),
    );
  }
}