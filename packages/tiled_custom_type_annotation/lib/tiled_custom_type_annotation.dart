import 'package:meta/meta_meta.dart';
import 'package:tiled/tiled.dart';
import 'package:json_annotation/json_annotation.dart';

export 'package:json_annotation/json_annotation.dart';

@Target({TargetKind.classType, TargetKind.enumType})
class TiledCustomType extends JsonSerializable {
  const TiledCustomType() : super(explicitToJson: true, includeIfNull: false);
}

@Target({TargetKind.enumType})
class TiledCustomEnum extends JsonEnum {
  const TiledCustomEnum() : super(alwaysCreate: true);
}

@Target({TargetKind.field})
class TiledCustomTypeMember extends JsonKey {
  final PropertyType? type;
  const TiledCustomTypeMember({
    this.type,
    super.defaultValue,
  });
}

enum MemberType {
  bool,
  color,
  float,
  file,
  int,
  object,
  string,
  class_,
}
