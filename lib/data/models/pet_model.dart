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
    @JsonKey(name: 'life_span') super.lifeSpan,
    super.weight,
    @JsonKey(name: 'reference_image_id') super.imageUrl,
    super.price = 100.0,
    super.distance = 2.5,
    super.gender = 'Male',
    super.age = '1 Year',
    super.isFavorite = false,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);
  Map<String, dynamic> toJson() => _$PetModelToJson(this);
}
