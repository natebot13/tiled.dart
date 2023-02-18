part of tiled;

/// The tiledProject
@JsonSerializable()
class TiledProject {
  TiledProject({
    required this.automappingRulesFile,
    required this.commands,
    required this.extensionsPath,
    required this.folders,
    required this.propertyTypes,
  });

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

@JsonSerializable()
class CustomPropertyType {
  int id;
  String type;
  String name;
  String color;
  List<String> useAs;
  List<Member> members;

  CustomPropertyType({
    required this.id,
    required this.type,
    required this.name,
    required this.color,
    required this.useAs,
    required this.members,
  });

  Map<String, dynamic> toJson() => _$CustomPropertyTypeToJson(this);
  factory CustomPropertyType.fromJson(Map<String, dynamic> json) =>
      _$CustomPropertyTypeFromJson(json);
}

@JsonSerializable()
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
