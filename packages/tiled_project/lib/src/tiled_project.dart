import 'package:json_annotation/json_annotation.dart';

part 'tiled_project.g.dart';

/// The tiledProject
@JsonSerializable()
class TiledProject {
  TiledProject({
    this.automappingRulesFile = '',
    List<Command>? commands,
    this.extensionsPath = '',
    List<String>? folders,
    List<CustomPropertyType>? propertyTypes,
  })  : commands = commands ?? [],
        folders = folders ?? [],
        propertyTypes = propertyTypes ?? [];

  String automappingRulesFile;
  final List<Command> commands;
  String extensionsPath;
  final List<String> folders;
  final List<CustomPropertyType> propertyTypes;

  Map<String, dynamic> toJson() => _$TiledProjectToJson(this);
  factory TiledProject.fromJson(Map<String, dynamic> json) =>
      _$TiledProjectFromJson(json);
}

@JsonSerializable()
class Command {
  String arguments;
  String command;
  bool enabled;
  String name;
  bool saveBeforeExecute;
  String shortcut;
  bool showOutput;
  String workingDirectory;

  Command({
    required this.arguments,
    required this.command,
    required this.enabled,
    required this.name,
    required this.saveBeforeExecute,
    required this.shortcut,
    required this.showOutput,
    required this.workingDirectory,
  });

  Map<String, dynamic> toJson() => _$CommandToJson(this);
  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class CustomPropertyType {
  int id = 0;
  String type = 'string';
  String name = '';
  String? storageType;
  String? color;
  List<String>? useAs;
  List<Member>? members;
  List<String>? values;
  bool? valuesAsFlags;

  CustomPropertyType();

  Map<String, dynamic> toJson() => _$CustomPropertyTypeToJson(this);
  factory CustomPropertyType.fromJson(Map<String, dynamic> json) =>
      _$CustomPropertyTypeFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class Member {
  String name;
  String type;
  String? propertyType;

  // Will always be a primitive, or another map
  Object value;

  Member({
    required this.name,
    required this.type,
    this.propertyType,
    required this.value,
  });

  Map<String, dynamic> toJson() => _$MemberToJson(this);
  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
