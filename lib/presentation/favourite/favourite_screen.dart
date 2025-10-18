import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/routing/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/pet_cubit.dart';
import '../bloc/pet_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/pet_card_grid.dart';

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
    // Load favorites when screen opens
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
            // Header
            _buildHeader(),
            // Categories
            _buildCategories(),
            // Favorites Grid
            Expanded(child: _buildFavoritesGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 24.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Your Favorite Pets',
            style: AppTextStyles.heading2,
          ),
        ],
      ),
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
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is PetError) {
          return _buildError(state.message);
        } else if (state is PetLoaded) {
          // Filter only favorites
          final favorites = state.pets.where((pet) => pet.isFavorite).toList();

          if (favorites.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final pet = favorites[index];
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

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(message, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Favorites Yet',
            style: AppTextStyles.heading3,
          ),
          SizedBox(height: 8.h),
          Text(
            'Start adding pets to your favorites!',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, Icons.home_outlined, 0),
              _buildNavItem(Icons.favorite, Icons.favorite_border, 1),
              _buildNavItem(Icons.chat_bubble, Icons.chat_bubble_outline, 2),
              _buildNavItem(Icons.person, Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData icon, int index) {
    final isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Don't update state, just pop - home screen will handle it
          context.pop();
        }
      },
      child: Icon(
        isActive ? activeIcon : icon,
        color: isActive ? AppColors.primary : AppColors.iconGray,
        size: 28.sp,
      ),
    );
  }
}
