// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiled_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TiledProject _$TiledProjectFromJson(Map<String, dynamic> json) => TiledProject(
      automappingRulesFile: json['automappingRulesFile'] as String? ?? '',
      commands: (json['commands'] as List<dynamic>?)
          ?.map((e) => Command.fromJson(e as Map<String, dynamic>))
          .toList(),
      extensionsPath: json['extensionsPath'] as String? ?? '',
      folders:
          (json['folders'] as List<dynamic>?)?.map((e) => e as String).toList(),
      propertyTypes: (json['propertyTypes'] as List<dynamic>?)
          ?.map((e) => CustomPropertyType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TiledProjectToJson(TiledProject instance) =>
    <String, dynamic>{
      'automappingRulesFile': instance.automappingRulesFile,
      'commands': instance.commands.map((e) => e.toJson()).toList(),
      'extensionsPath': instance.extensionsPath,
      'folders': instance.folders,
      'propertyTypes': instance.propertyTypes.map((e) => e.toJson()).toList(),
    };

Command _$CommandFromJson(Map<String, dynamic> json) => Command(
      arguments: json['arguments'] as String,
      command: json['command'] as String,
      enabled: json['enabled'] as bool,
      name: json['name'] as String,
      saveBeforeExecute: json['saveBeforeExecute'] as bool,
      shortcut: json['shortcut'] as String,
      showOutput: json['showOutput'] as bool,
      workingDirectory: json['workingDirectory'] as String,
    );

Map<String, dynamic> _$CommandToJson(Command instance) => <String, dynamic>{
      'arguments': instance.arguments,
      'command': instance.command,
      'enabled': instance.enabled,
      'name': instance.name,
      'saveBeforeExecute': instance.saveBeforeExecute,
      'shortcut': instance.shortcut,
      'showOutput': instance.showOutput,
      'workingDirectory': instance.workingDirectory,
    };

CustomPropertyType _$CustomPropertyTypeFromJson(Map<String, dynamic> json) =>
    CustomPropertyType()
      ..id = json['id'] as int
      ..type = json['type'] as String
      ..name = json['name'] as String
      ..storageType = json['storageType'] as String?
      ..color = json['color'] as String?
      ..useAs =
          (json['useAs'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..members = (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList()
      ..values =
          (json['values'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..valuesAsFlags = json['valuesAsFlags'] as bool?;

Map<String, dynamic> _$CustomPropertyTypeToJson(CustomPropertyType instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('storageType', instance.storageType);
  writeNotNull('color', instance.color);
  writeNotNull('useAs', instance.useAs);
  writeNotNull('members', instance.members?.map((e) => e.toJson()).toList());
  writeNotNull('values', instance.values);
  writeNotNull('valuesAsFlags', instance.valuesAsFlags);
  return val;
}

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      name: json['name'] as String,
      type: json['type'] as String,
      propertyType: json['propertyType'] as String?,
      value: json['value'] as Object,
    );

Map<String, dynamic> _$MemberToJson(Member instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('propertyType', instance.propertyType);
  val['value'] = instance.value;
  return val;
}
