import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_constants.dart';
import '../bloc/pet_cubit.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import 'widgets/home_header.dart';
import 'widgets/category_list.dart';
import 'widgets/pet_list_view.dart';

/// Home screen - Main screen with pet list
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = AppConstants.categoryAll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PetCubit>().loadPets();
      }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            _buildSearchBar(),
            CategoryList(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            const Expanded(child: PetListView()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SearchBarWidget(
        controller: _searchController,
        onChanged: (value) => context.read<PetCubit>().searchPets(value),
        hintText: 'Search',
        onFilterTap: () {},
      ),
    );
  }
}
