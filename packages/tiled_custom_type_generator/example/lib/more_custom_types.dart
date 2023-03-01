import 'package:tiled/tiled.dart';
import 'package:tiled_custom_type_annotation/tiled_custom_type_annotation.dart';

part 'more_custom_types.g.dart';

@TiledCustomEnum()
enum Thing {
  thing1,
  thing2,
}

@TiledCustomType()
class FileData {
  @TiledCustomTypeMember(type: PropertyType.file)
  String name;
  FileData({required this.name});

  Map<String, dynamic> toJson() => _$FileDataToJson(this);
  factory FileData.fromJson(Map<String, dynamic> json) =>
      _$FileDataFromJson(json);
}

@TiledCustomType()
class FilePair {
  final FileData first;
  final FileData second;
  FilePair({
    required this.first,
    required this.second,
  });

  Map<String, dynamic> toJson() => _$FilePairToJson(this);
  factory FilePair.fromJson(Map<String, dynamic> json) =>
      _$FilePairFromJson(json);
}
