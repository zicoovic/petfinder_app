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
import '../widgets/search_bar_widget.dart';
import '../widgets/category_chip.dart';
import '../widgets/pet_card_list.dart';

/// Home screen - Main screen with pet list
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = AppConstants.categoryAll;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load pets when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetCubit>().loadPets();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            // Search Bar
            _buildSearchBar(),
            // Categories
            _buildCategories(),
            // Pet List
            Expanded(child: _buildPetList()),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Find Your Forever Pet',
            style: AppTextStyles.heading2,
          ),
          Icon(
            Icons.notifications_outlined,
            size: 28.sp,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SearchBarWidget(
        controller: _searchController,
        onChanged: (value) {
          context.read<PetCubit>().searchPets(value);
        },
        hintText: 'Search',
        onFilterTap: () {
          // TODO: Implement filter
        },
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
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

  Widget _buildPetList() {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is PetError) {
          return _buildError(state.message);
        } else if (state is PetLoaded) {
          if (state.pets.isEmpty) {
            return _buildEmptyState();
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
          Icon(Icons.pets, size: 64.sp, color: AppColors.textLight),
          SizedBox(height: 16.h),
          Text('No pets found', style: AppTextStyles.bodyMedium),
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
      onTap: () async {
        if (index == 1) {
          // Navigate to favorites without changing local state
          await context.push(AppRoutes.favorites);
          // When returning from favorites, reload all pets and reset nav index
          if (mounted) {
            setState(() {
              _currentNavIndex = 0; // Reset to home
            });
            context.read<PetCubit>().loadPets();
          }
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
