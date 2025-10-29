import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/pet_cubit.dart';
import '../widgets/category_chip.dart';
import '../widgets/bottom_nav_bar.dart';
import 'widgets/adopted_header.dart';
import 'widgets/adopted_grid_view.dart';

/// Adopted screen - Shows adopted pets in grid
class AdoptedScreen extends StatefulWidget {
  const AdoptedScreen({super.key});

  @override
  State<AdoptedScreen> createState() => _AdoptedScreenState();
}

class _AdoptedScreenState extends State<AdoptedScreen> {
  String _selectedCategory = AppConstants.categoryAll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetCubit>().loadAdoptedPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const AdoptedHeader(),
            _buildCategories(),
            const Expanded(child: AdoptedGridView()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildCategories() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: AppConstants.petCategories.length,
        itemBuilder: (context, index) {
          final category = AppConstants.petCategories[index];
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: CategoryChip(
              label: category,
              isSelected: _selectedCategory == category,
              onTap: () => setState(() => _selectedCategory = category),
            ),
          );
        },
      ),
    );
  }
}