import 'package:json_annotation/json_annotation.dart';
import '../../core/entities/pet.dart';

part 'pet_model.g.dart';

@JsonSerializable()
class PetModel extends Pet {
  const PetModel({
    required super.id,
    required super.name,
    super.description,
    super.temperament,
    super.origin,
    super.lifeSpan,
    super.weight,
    super.imageUrl,
    super.price = 100.0,
    super.distance = 2.5,
    super.gender = 'Male',
    super.age = '1 Year',
    super.isFavorite = false,
    super.isAdopted = false,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      temperament: json['temperament'] as String?,
      origin: json['origin'] as String?,
      lifeSpan: json['life_span'] as String?,
      weight: _weightFromJson(json['weight']),
      imageUrl: json['reference_image_id'] as String?,
    );
  }

  static String? _weightFromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is Map) {
      return json['metric'] as String?;
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$PetModelToJson(this);
}
