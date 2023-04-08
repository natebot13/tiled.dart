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

  // Returns the default values of the custom types
  Map<String, Map<String, Object>> get defaultValues {
    final rootValues = {
      for (final type in propertyTypes) type.name: type.memberValues
    };
    for (final value in rootValues.values) {
      for (final name in value.keys) {
        value[name] = rootValues[name.toCapitalized()] ?? value[name]!;
      }
    }
    return rootValues;
  }

  Map<String, dynamic> toJson() => _$TiledProjectToJson(this);
  factory TiledProject.fromJson(Map<String, dynamic> json) =>
      _$TiledProjectFromJson(json);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
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

  Map<String, Object> get memberValues =>
      {for (final member in members ?? []) member.name: member.value};
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
