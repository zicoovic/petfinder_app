import 'package:flutter/material.dart';
import '../../core/entities/pet.dart';

class DetailsScreen extends StatelessWidget {
  final Pet pet;

  const DetailsScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: Center(
        child: Text('Details Screen for ${pet.name}'),
      ),
    );
  }
}