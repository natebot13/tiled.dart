// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_custom_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SomeCoolObject _$SomeCoolObjectFromJson(Map<String, dynamic> json) =>
    SomeCoolObject(
      choice: $enumDecode(_$MyEnumEnumMap, json['choice']),
      name: json['name'] as String,
      theAgeOfAThing: json['theAgeOfAThing'] as int,
      decimal: (json['decimal'] as num).toDouble(),
    );

Map<String, dynamic> _$SomeCoolObjectToJson(SomeCoolObject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'theAgeOfAThing': instance.theAgeOfAThing,
      'decimal': instance.decimal,
      'choice': _$MyEnumEnumMap[instance.choice]!,
    };

const _$MyEnumEnumMap = {
  MyEnum.one: 'one',
  MyEnum.two: 'two',
  MyEnum.three: 'three',
};
