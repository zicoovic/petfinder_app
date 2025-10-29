import 'package:equatable/equatable.dart';

/// Pet Entity - Pure business object (no JSON, no dependencies)
/// Represents a pet in the domain layer
class Pet extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? temperament;
  final String? origin;
  final String? lifeSpan;
  final String? weight;
  final String? imageUrl;

  // UI-related fields (can be mock data)
  final double? price;
  final double? distance; // in km
  final String? gender;
  final String? age;
  final bool isFavorite;
  final bool isAdopted;

  const Pet({
    required this.id,
    required this.name,
    this.description,
    this.temperament,
    this.origin,
    this.lifeSpan,
    this.weight,
    this.imageUrl,
    this.price,
    this.distance,
    this.gender,
    this.age,
    this.isFavorite = false,
    this.isAdopted = false,
  });

  /// Create a copy with modified fields
  Pet copyWith({
    String? id,
    String? name,
    String? description,
    String? temperament,
    String? origin,
    String? lifeSpan,
    String? weight,
    String? imageUrl,
    double? price,
    double? distance,
    String? gender,
    String? age,
    bool? isFavorite,
    bool? isAdopted,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      temperament: temperament ?? this.temperament,
      origin: origin ?? this.origin,
      lifeSpan: lifeSpan ?? this.lifeSpan,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      distance: distance ?? this.distance,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      isFavorite: isFavorite ?? this.isFavorite,
      isAdopted: isAdopted ?? this.isAdopted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    temperament,
    origin,
    lifeSpan,
    weight,
    imageUrl,
    price,
    distance,
    gender,
    age,
    isFavorite,
    isAdopted,
  ];
}
