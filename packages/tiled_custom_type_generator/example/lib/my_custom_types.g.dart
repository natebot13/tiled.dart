// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_custom_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SomeCoolObject _$SomeCoolObjectFromJson(Map<String, dynamic> json) =>
    SomeCoolObject(
      name: json['name'] as String,
      theAgeOfAThing: json['theAgeOfAThing'] as int,
      decimal: (json['decimal'] as num).toDouble(),
    );

Map<String, dynamic> _$SomeCoolObjectToJson(SomeCoolObject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'theAgeOfAThing': instance.theAgeOfAThing,
      'decimal': instance.decimal,
    };
