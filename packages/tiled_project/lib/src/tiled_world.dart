import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
part 'tiled_world.g.dart';

@JsonSerializable()
class TiledWorld {
  List<WorldMap> maps = [];
  TiledWorld({List<WorldMap>? maps}) : maps = maps ?? [];

  factory TiledWorld.fromJson(Map<String, dynamic> json) =>
      _$TiledWorldFromJson(json);
}

@JsonSerializable()
class WorldMap {
  String fileName;
  int width;
  int height;
  int x;
  int y;
  Rectangle get rect => Rectangle(x, y, width, height);
  WorldMap({
    required this.fileName,
    required this.width,
    required this.height,
    this.x = 0,
    this.y = 0,
  });

  factory WorldMap.fromJson(Map<String, dynamic> json) =>
      _$WorldMapFromJson(json);

  Map<String, dynamic> toJson() => _$WorldMapToJson(this);
}
