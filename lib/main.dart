import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/pet_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => injectionContainer<PetCubit>()),
        BlocProvider(create: (_) => injectionContainer<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: RouteGenerationConfig.goRouter,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
            ),
          );
        },
      ),
    );
  }
}
