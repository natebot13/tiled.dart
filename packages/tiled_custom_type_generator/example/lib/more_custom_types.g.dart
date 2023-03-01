// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'more_custom_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileData _$FileDataFromJson(Map<String, dynamic> json) => FileData(
      name: json['name'] as String,
    );

Map<String, dynamic> _$FileDataToJson(FileData instance) => <String, dynamic>{
      'name': instance.name,
    };

FilePair _$FilePairFromJson(Map<String, dynamic> json) => FilePair(
      first: FileData.fromJson(json['first'] as Map<String, dynamic>),
      second: FileData.fromJson(json['second'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FilePairToJson(FilePair instance) => <String, dynamic>{
      'first': instance.first.toJson(),
      'second': instance.second.toJson(),
    };

const _$ThingEnumMap = {
  Thing.thing1: 'thing1',
  Thing.thing2: 'thing2',
};
