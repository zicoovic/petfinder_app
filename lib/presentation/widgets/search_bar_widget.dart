import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom search bar widget
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onFilterTap,
    this.hintText = 'Search',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Icon(
              Icons.search,
              color: Theme.of(context).iconTheme.color,
              size: 24.sp,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onFilterTap != null)
            GestureDetector(
              onTap: onFilterTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Icon(
                  Icons.tune,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  size: 24.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
