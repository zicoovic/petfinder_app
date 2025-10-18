import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/pet_cubit.dart';
import '../widgets/category_chip.dart';
import 'widgets/favorite_header.dart';
import 'widgets/favorites_grid_view.dart';
import 'widgets/favorite_bottom_nav.dart';

/// Favorites screen - Shows favorite pets in grid
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String _selectedCategory = AppConstants.categoryAll;
  final int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetCubit>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FavoriteHeader(),
            _buildCategories(),
            const Expanded(child: FavoritesGridView()),
          ],
        ),
      ),
      bottomNavigationBar: FavoriteBottomNav(currentIndex: _currentNavIndex),
    );
  }

  Widget _buildCategories() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: AppConstants.petCategories.map((category) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: CategoryChip(
              label: category,
              isSelected: _selectedCategory == category,
              onTap: () => setState(() => _selectedCategory = category),
            ),
          );
        }).toList(),
      ),
    );
  }
}
