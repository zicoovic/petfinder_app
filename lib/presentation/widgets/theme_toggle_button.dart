import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/theme/theme_state.dart';

/// Theme toggle button that switches between light and dark mode
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.isDark;

        return IconButton(
          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(isDark),
              size: 24.sp,
            ),
          ),
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        );
      },
    );
  }
}
