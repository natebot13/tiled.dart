// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiled_world.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TiledWorld _$TiledWorldFromJson(Map<String, dynamic> json) => TiledWorld(
      maps: (json['maps'] as List<dynamic>?)
          ?.map((e) => WorldMap.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TiledWorldToJson(TiledWorld instance) =>
    <String, dynamic>{
      'maps': instance.maps.map((e) => e.toJson()).toList(),
    };

WorldMap _$WorldMapFromJson(Map<String, dynamic> json) => WorldMap(
      fileName: json['fileName'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      x: json['x'] as int? ?? 0,
      y: json['y'] as int? ?? 0,
    );

Map<String, dynamic> _$WorldMapToJson(WorldMap instance) => <String, dynamic>{
      'fileName': instance.fileName,
      'width': instance.width,
      'height': instance.height,
      'x': instance.x,
      'y': instance.y,
    };
