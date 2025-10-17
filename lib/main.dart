import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/bloc/pet_cubit.dart';
import 'presentation/bloc/pet_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => di.injectionContainer<PetCubit>()..loadPets(),
        child: const TestScreen(),
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing PetFinder')),
      body: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is PetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PetLoaded) {
            return ListView.builder(
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return ListTile(
                  title: Text(pet.name),
                  subtitle: Text(pet.origin ?? 'Unknown origin'),
                );
              },
            );
          } else if (state is PetError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Press button to load pets'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<PetCubit>().loadPets(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
