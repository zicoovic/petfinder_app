// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetModel _$PetModelFromJson(Map<String, dynamic> json) => PetModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  temperament: json['temperament'] as String?,
  origin: json['origin'] as String?,
  lifeSpan: json['life_span'] as String?,
  weight: json['weight'] as String?,
  imageUrl: json['reference_image_id'] as String?,
  price: (json['price'] as num?)?.toDouble() ?? 100.0,
  distance: (json['distance'] as num?)?.toDouble() ?? 2.5,
  gender: json['gender'] as String? ?? 'Male',
  age: json['age'] as String? ?? '1 Year',
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$PetModelToJson(PetModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'temperament': instance.temperament,
  'origin': instance.origin,
  'life_span': instance.lifeSpan,
  'weight': instance.weight,
  'reference_image_id': instance.imageUrl,
  'price': instance.price,
  'distance': instance.distance,
  'gender': instance.gender,
  'age': instance.age,
  'isFavorite': instance.isFavorite,
};
