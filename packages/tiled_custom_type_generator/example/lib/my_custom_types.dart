import 'package:tiled_custom_type_annotation/tiled_custom_type_annotation.dart';

part 'my_custom_types.g.dart';

@TiledCustomEnum()
enum MyEnum { one, two, three }

@TiledCustomType()
class SomeCoolObject {
  final String name;
  final int theAgeOfAThing;
  final double decimal;
  final MyEnum choice;
  SomeCoolObject(
      {required this.choice,
      required this.name,
      required this.theAgeOfAThing,
      required this.decimal});

  Map<String, dynamic> toJson() => _$SomeCoolObjectToJson(this);
  factory SomeCoolObject.fromJson(Map<String, dynamic> json) =>
      _$SomeCoolObjectFromJson(json);
}
