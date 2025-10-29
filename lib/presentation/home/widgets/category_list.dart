import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/pet_cubit.dart';
import '../../bloc/pet_state.dart';
import '../../widgets/category_chip.dart';

class CategoryList extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        List<String> categories = ['All'];

        if (state is PetLoaded && state.allPets != null && state.allPets!.isNotEmpty) {
          final breeds = state.allPets!.map((pet) => pet.name).toSet().toList();
          breeds.sort();
          categories.addAll(breeds);
        }

        return Container(
          margin: EdgeInsets.symmetric(vertical: 20.h),
          height: 40.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: CategoryChip(
                  label: category,
                  isSelected: selectedCategory == category,
                  onTap: () {
                    onCategorySelected(category);
                    context.read<PetCubit>().filterByBreed(category);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}